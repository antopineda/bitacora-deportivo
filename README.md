# 🏅 Bitácora Deportivo

Aplicación web para gestionar y documentar juegos y actividades deportivas.

## 🚀 Stack Tecnológico

- **Ruby**: 3.2.9
- **Rails**: 7.2.3
- **Base de datos**: PostgreSQL 16
- **Almacenamiento**: AWS S3
- **Servidor web**: Puma
- **Proxy reverso**: Caddy
- **Contenedores**: Docker & Docker Compose
- **Frontend**: Bootstrap 5, Hotwire (Turbo & Stimulus)

## 📦 Características

- ✅ CRUD completo de juegos deportivos
- ✅ Carga de imágenes con Active Storage
- ✅ Almacenamiento en S3
- ✅ SSL automático con Caddy
- ✅ Diseño responsive con Bootstrap
- ✅ Dockerizado para fácil deploy

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

# Levantar con configuración local (sin SSL)
docker-compose -f docker-compose.local.yml build
docker-compose -f docker-compose.local.yml up -d

# Ejecutar migraciones
docker-compose -f docker-compose.local.yml exec web bin/rails db:prepare

# Acceder a la aplicación
open http://localhost:3000
```

### Configurar AWS S3 (Opcional para desarrollo local)

Ver instrucciones detalladas en [AWS_S3_SETUP.md](AWS_S3_SETUP.md)

## 🚀 Deploy en Producción

Para desplegar en EC2 con dominio personalizado, sigue la guía completa en [DEPLOY.md](DEPLOY.md)

### Resumen rápido:

```bash
# En EC2
git clone https://github.com/antopineda/bitacora-deportivo.git
cd bitacora-deportivo
cp .env.production .env
# Editar .env con tus valores
docker-compose build
docker-compose up -d
docker-compose exec web bin/rails db:prepare
```

## 📁 Estructura del Proyecto

```
bitacora-deportivo/
├── app/
│   ├── controllers/     # Controladores
│   ├── models/          # Modelos
│   ├── views/           # Vistas
│   └── assets/          # Assets (CSS, JS)
├── config/
│   ├── database.yml     # Configuración BD
│   ├── storage.yml      # Configuración S3
│   └── routes.rb        # Rutas
├── db/
│   └── migrate/         # Migraciones
├── docker-compose.yml   # Producción
├── docker-compose.local.yml  # Desarrollo local
├── Dockerfile           # Imagen Docker
├── Caddyfile           # Configuración Caddy (producción)
└── Caddyfile.local     # Configuración Caddy (local)
```

## 🔧 Comandos Útiles

```bash
# Ver logs
docker-compose logs -f web

# Consola de Rails
docker-compose exec web bin/rails console

# Ejecutar migraciones
docker-compose exec web bin/rails db:migrate

# Ver estado de migraciones
docker-compose exec web bin/rails db:migrate:status

# Reiniciar servicios
docker-compose restart web
```

## 🌐 Configuración de Dominio

El proyecto está configurado para usar `www.javidonoso.me`. Para cambiar el dominio:

1. Edita `Caddyfile`
2. Apunta tu dominio a la IP de tu servidor EC2
3. Caddy obtendrá automáticamente certificados SSL de Let's Encrypt

## 📝 Documentación Adicional

- [Guía de Deploy](DEPLOY.md) - Instrucciones completas de deploy en EC2
- [Configuración AWS S3](AWS_S3_SETUP.md) - Setup de almacenamiento S3

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es privado y de uso educativo.

## 👥 Autor

- Antonia Pineda - [@antopineda](https://github.com/antopineda)
