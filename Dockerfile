# syntax=docker/dockerfile:1.7

# --- Imagen base estable (Debian bookworm) ---
ARG RUBY_VERSION=3.2.9
FROM ruby:${RUBY_VERSION}-bookworm-slim AS base

WORKDIR /rails

<<<<<<< HEAD
# Paquetes base de runtime
RUN set -eux; \
    apt-get -o Acquire::Retries=3 update -qq; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libjemalloc2 \
      libvips \
      postgresql-client; \
    rm -rf /var/lib/apt/lists/*
=======
# Paquetes base (producción)
RUN set -eux; \
    apt-get update -qq; \
    if apt-cache show libvips >/dev/null 2>&1; then \
      LIBVIPS_PKG=libvips; \
    else \
      LIBVIPS_PKG=libvips42; \
    fi; \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 "$LIBVIPS_PKG" postgresql-client; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives
>>>>>>> f63e40634d4a69e29889569c9212496783d73367

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
<<<<<<< HEAD
    apt-get -o Acquire::Retries=3 update -qq; \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config; \
    rm -rf /var/lib/apt/lists/*
=======
    apt-get update -qq; \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libyaml-dev pkg-config; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives
>>>>>>> f63e40634d4a69e29889569c9212496783d73367

# En build permitimos actualizar lock y compilar sin modo frozen
ENV BUNDLE_DEPLOYMENT=0 \
    BUNDLE_FROZEN=false \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production

# Instalar gems primero (mejor cache)
COPY Gemfile Gemfile.lock ./

# Cache de bundler entre builds (requiere BuildKit)
RUN --mount=type=cache,target=/usr/local/bundle \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
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
