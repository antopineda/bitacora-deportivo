# 🏅 Bitácora Deportivo

Aplicación web para gestionar y documentar juegos, dinámicas y aplausos deportivos.

## 🚀 Stack Tecnológico

- **Ruby**: 3.2.9
- **Rails**: 7.2.3
- **Base de datos**: PostgreSQL 16
- **Almacenamiento**: AWS S3 (Active Storage)
- **Servidor web**: Puma
- **Proxy reverso**: Caddy 2 (SSL automático con Let's Encrypt)
- **Contenedores**: Docker & Docker Compose
- **Frontend**: Bootstrap 5, Hotwire (Turbo & Stimulus)

## 📦 Características

- ✅ CRUD completo de juegos deportivos
- ✅ CRUD completo de dinámicas
- ✅ CRUD completo de aplausos
- ✅ Carga de imágenes con Active Storage + S3
- ✅ SSL automático con Caddy y Let's Encrypt
- ✅ Diseño responsive con Bootstrap 5
- ✅ Dockerizado para fácil deploy
- ✅ Optimizado para EC2 con bajo consumo de RAM

## 🛠️ Desarrollo Local

### Pre-requisitos

- Docker y Docker Compose instalados
- Git

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/antopineda/bitacora-deportivo.git
cd bitacora-deportivo

# Copiar archivo de configuración
cp .env.example .env

# Editar .env y configurar las variables necesarias
nano .env

# Construir y levantar contenedores
docker compose build
docker compose up -d

# Ejecutar migraciones
docker compose exec web bin/rails db:prepare

# Acceder a la aplicación
open http://localhost:3000
```

## 🚀 Deploy en Producción (EC2)

### Pre-requisitos en EC2
- Ubuntu 22.04 LTS
- Docker y Docker Compose instalados
- Dominio apuntando a la IP del servidor
- Mínimo 16-20GB de disco
- 2GB de swap recomendado

### Despliegue inicial

```bash
# En EC2
git clone https://github.com/antopineda/bitacora-deportivo.git
cd bitacora-deportivo

# Configurar variables de entorno
cp .env.example .env
nano .env
# Configurar: RAILS_MASTER_KEY, DATABASE_URL, AWS_ACCESS_KEY_ID, 
# AWS_SECRET_ACCESS_KEY, AWS_REGION, AWS_BUCKET

# Construir y levantar
docker compose build
docker compose up -d

# Preparar base de datos
docker compose exec web bin/rails db:prepare
```

### Actualizaciones

```bash
cd ~/bitacora-deportivo
git pull
docker compose build web
docker compose up -d
docker compose exec web bin/rails db:migrate
```

## 📁 Estructura del Proyecto

```
bitacora-deportivo/
├── app/
│   ├── controllers/     # game_controller, dynamics_controller, applauses_controller
│   ├── models/          # game, dynamic, applause (con Active Storage)
│   ├── views/           # Vistas Bootstrap 5
│   │   ├── games/
│   │   ├── dynamics/
│   │   └── applauses/
│   └── assets/          # Assets (CSS, JS)
├── config/
│   ├── database.yml     # Configuración PostgreSQL
│   ├── storage.yml      # Configuración S3
│   ├── routes.rb        # Rutas de la app
│   └── environments/
│       └── production.rb  # force_ssl = true
├── db/
│   └── migrate/         # Migraciones (games, dynamics, applauses, active_storage)
├── docker-compose.yml   # Configuración producción (web, db, caddy)
├── Dockerfile           # Imagen optimizada para EC2
└── Caddyfile           # SSL automático con Let's Encrypt
```

## 🔧 Comandos Útiles

```bash
# Ver logs
docker compose logs -f web
docker compose logs -f caddy

# Consola de Rails
docker compose exec web bin/rails console

# Ejecutar migraciones
docker compose exec web bin/rails db:migrate

# Ver estado de migraciones
docker compose exec web bin/rails db:migrate:status

# Reiniciar servicios
docker compose restart web
docker compose restart caddy

# Ver estado de contenedores
docker compose ps
```

## 🌐 SSL y Dominio

El proyecto usa **Caddy 2** que obtiene automáticamente certificados SSL de Let's Encrypt:

- **Dominio**: www.javidonoso.me y javidonoso.me
- **SSL**: Renovación automática cada 90 días
- **HTTPS**: Forzado en producción
- **Límite Let's Encrypt**: 5 certificados por dominio por semana

### Troubleshooting SSL
Si llegas al límite de certificados:
- Espera 7 días desde el último certificado
- Los certificados se renuevan automáticamente
- No requiere intervención manual

## 🔐 Variables de Entorno Requeridas

```bash
# Rails
RAILS_MASTER_KEY=<tu_master_key>
DATABASE_URL=postgres://postgres:password@db:5432/app_production

# AWS S3
AWS_ACCESS_KEY_ID=<tu_access_key>
AWS_SECRET_ACCESS_KEY=<tu_secret_key>
AWS_REGION=us-east-2
AWS_BUCKET=bitacora-deportivo-prod
```

## 📄 Licencia

Este proyecto es privado y de uso educativo.
- Antonia Pineda - [@antopineda](https://github.com/antopineda)
