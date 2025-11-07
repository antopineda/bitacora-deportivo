# syntax = docker/dockerfile:1

# Imagen base
ARG RUBY_VERSION=3.2.9
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

# Carpeta de la app
WORKDIR /rails

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

# Variables comunes de producción (solo para la imagen final; en build las sobreescribimos)
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
    apt-get update -qq; \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libyaml-dev pkg-config; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# ⚠️ En build NO usamos deployment/frozen para que pueda regenerar Gemfile.lock si cambian dependencias
ENV BUNDLE_DEPLOYMENT=0 \
    BUNDLE_FROZEN=false \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production

# Instalar gems primero (mejor cache)
COPY Gemfile Gemfile.lock ./
# Si quieres cachear bundle entre builds, puedes usar:
# RUN --mount=type=cache,target=/usr/local/bundle \
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copiar el resto del código
COPY . .

# Precompile bootsnap de app/lib para arranque rápido
RUN bundle exec bootsnap precompile app/ lib/

# Precompilar assets en producción (sin requerir master key)
# SECRET_KEY_BASE_DUMMY permite compilar sin credenciales
ENV SECRET_KEY_BASE_DUMMY=1
RUN ./bin/rails assets:precompile

# =========================
# Imagen final (runtime)
# =========================
FROM base

# En la imagen final sí usamos deployment (frozen) para runtime confiable
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_FROZEN=true

# Copiar gems y app desde build
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Usuario no root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint (prepara DB en arranque)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Exponer y lanzar servidor
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
