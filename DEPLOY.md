# 🚀 Guía de Deploy en EC2

Esta guía te ayudará a desplegar la aplicación Bitácora Deportivo en una instancia EC2 de AWS.

## 📋 Pre-requisitos

### En AWS:
- ✅ Instancia EC2 (Ubuntu 22.04 LTS recomendado)
- ✅ Bucket S3 creado (`bitacora-deportivo-prod` o el nombre que hayas elegido)
- ✅ Credenciales IAM con acceso al bucket S3
- ✅ Dominio apuntando a la IP de tu EC2 (www.javidonoso.me)

### Puertos abiertos en Security Group:
- Puerto 80 (HTTP)
- Puerto 443 (HTTPS)
- Puerto 22 (SSH)

## 🔧 Instalación en EC2

### 1. Conectarse a EC2

```bash
ssh -i tu-llave.pem ubuntu@tu-ip-ec2
```

### 2. Instalar Docker y Docker Compose

```bash
# Actualizar paquetes
sudo apt update && sudo apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo apt install docker-compose -y

# Reiniciar sesión para aplicar cambios
exit
# Volver a conectarse por SSH
```

### 3. Clonar el repositorio

```bash
# Instalar git si no está instalado
sudo apt install git -y

# Clonar el proyecto
git clone https://github.com/antopineda/bitacora-deportivo.git
cd bitacora-deportivo
git checkout develop  # o la rama que quieras desplegar
```

### 4. Configurar variables de entorno

```bash
# Copiar el archivo de plantilla
cp .env.production .env

# Editar el archivo .env
nano .env
```

Completa los valores:
```env
RAILS_ENV=production
DATABASE_URL=postgres://postgres:TU_PASSWORD_SEGURA@db:5432/app_production
RAILS_MASTER_KEY=0da63500cf73777007e774915677f8fb
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true
```

**IMPORTANTE**: Cambia `TU_PASSWORD_SEGURA` por una contraseña segura para PostgreSQL.

### 5. Configurar credenciales de AWS S3

En tu máquina LOCAL (no en EC2), edita las credenciales:

```bash
EDITOR="nano" bin/rails credentials:edit
```

Agrega:
```yaml
aws:
  access_key_id: TU_AWS_ACCESS_KEY_ID
  secret_access_key: TU_AWS_SECRET_ACCESS_KEY
```

Luego sube los cambios a git:
```bash
git add config/credentials.yml.enc
git commit -m "Add AWS credentials"
git push
```

En EC2, haz pull de los cambios:
```bash
git pull
```

### 6. Verificar configuración de S3

Edita `config/storage.yml` si tu bucket o región son diferentes:

```bash
nano config/storage.yml
```

### 7. Construir y levantar los contenedores

```bash
# Construir la imagen
docker-compose build

# Levantar los servicios
docker-compose up -d

# Ver los logs
docker-compose logs -f
```

### 8. Configurar la base de datos

```bash
# Ejecutar migraciones
docker-compose exec web bin/rails db:prepare

# Verificar que todo esté bien
docker-compose exec web bin/rails db:migrate:status
```

### 9. Verificar que funciona

```bash
# Desde EC2
curl http://localhost

# Desde tu navegador (después de que DNS propague)
# https://www.javidonoso.me
```

## 🔄 Actualizar la aplicación

```bash
# Conectarse a EC2
ssh -i tu-llave.pem ubuntu@tu-ip-ec2
cd bitacora-deportivo

# Obtener últimos cambios
git pull

# Reconstruir si hay cambios en Gemfile o assets
docker-compose build web

# Reiniciar servicios
docker-compose restart web

# Si hay migraciones nuevas
docker-compose exec web bin/rails db:migrate
```

## 🛠️ Comandos útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f web

# Ver solo logs de errores
docker-compose logs web | grep -i error

# Reiniciar solo el servicio web
docker-compose restart web

# Acceder a la consola de Rails
docker-compose exec web bin/rails console

# Ver estado de los contenedores
docker-compose ps

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (¡CUIDADO! Borra la BD)
docker-compose down -v
```

## 🔍 Troubleshooting

### La aplicación no arranca

```bash
# Ver logs completos
docker-compose logs web

# Verificar que la base de datos esté corriendo
docker-compose ps db

# Verificar variables de entorno
docker-compose exec web env | grep RAILS
```

### Problemas con SSL/Caddy

```bash
# Ver logs de Caddy
docker-compose logs caddy

# Verificar que el dominio apunta a la IP correcta
dig www.javidonoso.me
```

### Problemas con S3

```bash
# Verificar credenciales
docker-compose exec web bin/rails console
# En la consola:
# Rails.application.credentials.dig(:aws, :access_key_id)

# Probar conexión a S3
docker-compose exec web bin/rails runner "puts ActiveStorage::Blob.service.bucket"
```

## 📊 Monitoreo

### Ver uso de recursos

```bash
# Uso de Docker
docker stats

# Uso del sistema
htop
```

### Logs de la aplicación

```bash
# En tiempo real
docker-compose logs -f web

# Últimas 100 líneas
docker-compose logs --tail=100 web
```

## 🔒 Seguridad

- ✅ Nunca subas el archivo `.env` a git
- ✅ Nunca subas `config/master.key` a git
- ✅ Usa contraseñas seguras para la base de datos
- ✅ Mantén Docker y el sistema operativo actualizados
- ✅ Configura un firewall (ufw) en EC2
- ✅ Usa SSL/TLS (Caddy lo hace automáticamente)

## 🆘 Soporte

Si encuentras problemas:
1. Revisa los logs: `docker-compose logs web`
2. Verifica las variables de entorno en `.env`
3. Asegúrate de que el `master.key` sea correcto
4. Revisa que las credenciales de AWS S3 estén bien configuradas
