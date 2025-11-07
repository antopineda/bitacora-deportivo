# syntax=docker/dockerfile:1.7

# --- Imagen base estable (Debian bookworm) ---
ARG RUBY_VERSION=3.2.9
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# Paquetes base de runtime (mínimos para producción)
RUN set -eux; \
    apt-get -o Acquire::Retries=3 update -qq; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libjemalloc2 \
      postgresql-client; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Variables comunes de producción
ENV RAILS_ENV=production \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

# =========================
# Etapa de build
# =========================
FROM base AS build

# Paquetes para compilar gems
RUN set -eux; \
    apt-get -o Acquire::Retries=3 update -qq; \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config; \
    rm -rf /var/lib/apt/lists/*

# En build permitimos actualizar lock y compilar sin modo frozen
ENV BUNDLE_DEPLOYMENT=0 \
    BUNDLE_FROZEN=false \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production

# Instalar gems primero (mejor cache)
COPY Gemfile Gemfile.lock ./

# Instalar gems de forma más eficiente en espacio
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 1 --retry 3 && \
    bundle clean --force && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git \
           /tmp/* /var/tmp/* && \
    bundle exec bootsnap precompile --gemfile

# Copiar el resto del código
COPY . .

# Precompile bootsnap de app/lib para arranque rápido
RUN bundle exec bootsnap precompile app/ lib/

# Precompilar assets en producción sin master key real
# (Rails 7.2 requiere SECRET_KEY_BASE presente)
ENV SECRET_KEY_BASE=dummy
RUN ./bin/rails assets:precompile

# =========================
# Imagen final (runtime)
# =========================
FROM base

# En runtime sí usamos deployment/frozen
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_FROZEN=true

# Copiar gems y app desde build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Usuario no root
RUN set -eux; \
    groupadd --system --gid 1000 rails; \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash; \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint (migra DB en arranque si así lo haces ahí dentro)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
