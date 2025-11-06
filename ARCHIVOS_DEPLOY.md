# 📦 Archivos de Deploy - Resumen

## ✅ Archivos Creados/Actualizados

### Documentación
- **README.md** - Documentación principal del proyecto actualizada
- **DEPLOY.md** - Guía completa de deploy en EC2
- **DEPLOY_CHECKLIST.md** - Checklist paso a paso para deploy
- **AWS_S3_SETUP.md** - Instrucciones para configurar AWS S3

### Configuración
- **.env.example** - Plantilla de variables de entorno (se sube a git)
- **.env.production** - Plantilla específica para producción en EC2 (se sube a git)
- **.env** - Archivo local (NO se sube a git)
- **.gitignore** - Actualizado para proteger archivos sensibles

### Scripts de Deploy
- **deploy.sh** - Script automatizado de deploy/actualización
- **setup-ec2.sh** - Script de configuración inicial de EC2

### Configuración de Producción
- **Caddyfile** - Configurado para www.javidonoso.me
- **Caddyfile.local** - Configuración local sin SSL
- **docker-compose.yml** - Configuración de producción
- **docker-compose.local.yml** - Configuración para desarrollo local

### Archivos de Rails Actualizados
- **config/environments/production.rb** - Force SSL configurable
- **config/storage.yml** - Configuración de S3 documentada

## 🚀 Cómo Usar

### 1. Primera Vez en EC2

```bash
# 1. En tu máquina local, agrega credenciales de AWS
EDITOR="nano" bin/rails credentials:edit
# Agrega:
# aws:
#   access_key_id: TU_KEY
#   secret_access_key: TU_SECRET

# 2. Commit y push
git add .
git commit -m "Preparar para deploy en EC2"
git push

# 3. En EC2
wget https://raw.githubusercontent.com/antopineda/bitacora-deportivo/develop/setup-ec2.sh
chmod +x setup-ec2.sh
./setup-ec2.sh

# 4. Cierra sesión y vuelve a conectarte

# 5. Clona el repo
git clone https://github.com/antopineda/bitacora-deportivo.git
cd bitacora-deportivo

# 6. Configura variables
cp .env.production .env
nano .env  # Edita con tus valores

# 7. Deploy
./deploy.sh
```

### 2. Actualizaciones Futuras

```bash
# En EC2
cd bitacora-deportivo
./deploy.sh
```

## ⚠️ IMPORTANTE - Antes de Deploy

### En tu máquina local:
1. ✅ Configura AWS S3 credentials: `bin/rails credentials:edit`
2. ✅ Verifica que el bucket S3 exista
3. ✅ Commit y push todos los cambios

### En AWS:
1. ✅ EC2 corriendo con Ubuntu
2. ✅ Security Group: puertos 80, 443, 22 abiertos
3. ✅ Bucket S3 creado: `bitacora-deportivo-prod`
4. ✅ Dominio apuntando a EC2: `www.javidonoso.me`

### En EC2:
1. ✅ Copiar `.env.production` como `.env`
2. ✅ Editar `.env` con tus valores
3. ✅ Cambiar contraseña de PostgreSQL en `.env`
4. ✅ Verificar que existe `config/master.key`

## 🔒 Archivos que NO se suben a git

Estos archivos están protegidos por `.gitignore`:
- `.env` (variables reales)
- `config/master.key` (clave de encriptación)
- `*.local*` (archivos locales)
- `/storage/*` (archivos subidos)
- `/log/*` (logs)

## 📋 Checklist Rápido

Antes de hacer deploy, verifica:

- [ ] Credenciales de AWS en `credentials.yml.enc`
- [ ] Bucket S3 existe
- [ ] Dominio apunta a EC2
- [ ] Security Group configurado
- [ ] `.env` editado con valores correctos
- [ ] Todos los cambios están en git

## 🆘 Si algo sale mal

1. Ver logs: `docker-compose logs web`
2. Ver el checklist completo: `DEPLOY_CHECKLIST.md`
3. Ver la guía completa: `DEPLOY.md`

## 🎯 Próximos Pasos

1. Configurar credenciales de AWS S3
2. Hacer commit y push de los cambios
3. Seguir la guía en `DEPLOY.md`
4. Usar el checklist en `DEPLOY_CHECKLIST.md`

¡Listo para deploy! 🚀
