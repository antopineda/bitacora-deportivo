# 🔧 Configuración de Variables de Entorno en EC2

## Paso 1: Editar el archivo .env en EC2

Una vez que hayas clonado el repositorio en EC2, necesitas configurar las variables de entorno:

```bash
cd bitacora-deportivo
cp .env.production .env
nano .env
```

## Paso 2: Completar los valores

### Variables OBLIGATORIAS:

```env
# Entorno (dejar como está)
RAILS_ENV=production

# Base de datos PostgreSQL
# ⚠️ CAMBIAR: Pon una contraseña segura
DATABASE_URL=postgres://postgres:TU_PASSWORD_AQUI@db:5432/app_production

# Rails Master Key (copiar de config/master.key)
# ⚠️ VERIFICAR: Debe ser exactamente la misma que en config/master.key
RAILS_MASTER_KEY=0da63500cf73777007e774915677f8fb
```

### Variables OPCIONALES (ya configuradas):

```env
# Configuración de Puma (dejar como está)
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2

# Logging (dejar como está)
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true
```

### Variables para DESARROLLO LOCAL (NO usar en EC2):

```env
# Solo descomenta si estás haciendo pruebas sin SSL
# FORCE_SSL=false
```

## Paso 3: Generar contraseña segura para PostgreSQL

```bash
# En EC2, genera una contraseña aleatoria:
openssl rand -base64 32

# Copia el resultado y úsalo en DATABASE_URL
```

## Paso 4: Verificar config/master.key

El archivo `config/master.key` debe estar presente en el repositorio con el contenido:

```
0da63500cf73777007e774915677f8fb
```

Si no existe, créalo:

```bash
echo "0da63500cf73777007e774915677f8fb" > config/master.key
```

## Paso 5: Configurar AWS S3 Credentials

### En tu MÁQUINA LOCAL (no en EC2):

```bash
# Editar credenciales encriptadas
EDITOR="nano" bin/rails credentials:edit
```

Agrega estas líneas:

```yaml
aws:
  access_key_id: AKIAIOSFODNN7EXAMPLE  # ⚠️ Cambia por tu AWS Access Key ID
  secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY  # ⚠️ Cambia por tu Secret Access Key
```

Guarda y cierra el editor (Ctrl+X, luego Y, luego Enter).

### Commit y push los cambios:

```bash
git add config/credentials.yml.enc
git commit -m "Add AWS S3 credentials"
git push
```

### En EC2, obtén los cambios:

```bash
git pull
```

## Paso 6: Verificar configuración del Bucket S3

En `config/storage.yml` deberías tener:

```yaml
amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: us-east-2  # ⚠️ Cambia si tu bucket está en otra región
  bucket: bitacora-deportivo-prod  # ⚠️ Cambia si tu bucket tiene otro nombre
```

## 📝 Ejemplo Completo de .env en EC2

```env
RAILS_ENV=production
DATABASE_URL=postgres://postgres:Mi_Contraseña_Segura_123!@db:5432/app_production
RAILS_MASTER_KEY=0da63500cf73777007e774915677f8fb
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true
```

## ✅ Checklist de Verificación

Antes de ejecutar `./deploy.sh`, verifica:

- [ ] El archivo `.env` existe en el directorio raíz
- [ ] La contraseña de PostgreSQL es segura y única
- [ ] El `RAILS_MASTER_KEY` coincide con `config/master.key`
- [ ] Las credenciales de AWS S3 están configuradas en `credentials.yml.enc`
- [ ] El nombre del bucket S3 en `config/storage.yml` es correcto
- [ ] La región del bucket S3 en `config/storage.yml` es correcta

## 🔐 Seguridad

### ⚠️ NUNCA hagas esto:
- ❌ NO subas `.env` a git
- ❌ NO subas `config/master.key` a git
- ❌ NO uses contraseñas débiles
- ❌ NO compartas tus credenciales de AWS

### ✅ SÍ haz esto:
- ✅ Usa contraseñas fuertes y únicas
- ✅ Mantén `config/master.key` seguro
- ✅ Usa credenciales IAM con permisos mínimos
- ✅ Cambia las contraseñas periódicamente

## 🆘 Problemas Comunes

### Error: "key must be 16 bytes"
- **Causa**: El `RAILS_MASTER_KEY` está mal
- **Solución**: Verifica que coincida exactamente con `config/master.key`

### Error: "Access Denied" al subir imágenes
- **Causa**: Credenciales de AWS incorrectas o permisos insuficientes
- **Solución**: Verifica credenciales y permisos IAM en el bucket S3

### Error: "could not connect to server"
- **Causa**: PostgreSQL no está corriendo
- **Solución**: `docker-compose ps db` para verificar

## 📞 Siguiente Paso

Una vez configurado el `.env`, ejecuta:

```bash
./deploy.sh
```

¡Y tu aplicación estará en producción! 🚀
