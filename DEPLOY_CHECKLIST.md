# ✅ Checklist de Deploy

Usa este checklist antes de hacer deploy a producción.

## Pre-Deploy

### Configuración Local
- [ ] Las credenciales de AWS S3 están configuradas en `config/credentials.yml.enc`
- [ ] El archivo `.env.production` tiene todos los valores correctos
- [ ] El `config/master.key` es el correcto
- [ ] El bucket S3 está creado y configurado
- [ ] Las migraciones están funcionando localmente

### Repositorio
- [ ] Todos los cambios están commiteados
- [ ] El código está en la rama correcta (develop/main)
- [ ] El `.gitignore` está correctamente configurado
- [ ] No hay archivos sensibles en el repo (.env, master.key, etc.)

### AWS
- [ ] La instancia EC2 está corriendo
- [ ] El Security Group tiene los puertos 80, 443 y 22 abiertos
- [ ] El bucket S3 existe (`bitacora-deportivo-prod`)
- [ ] Las credenciales IAM tienen permisos para S3
- [ ] El dominio (www.javidonoso.me) apunta a la IP de EC2

## Deploy en EC2

### Primera vez (Setup inicial)
- [ ] Conectarse a EC2 via SSH
- [ ] Ejecutar `setup-ec2.sh` para instalar Docker
- [ ] Cerrar sesión y volver a conectarse
- [ ] Clonar el repositorio
- [ ] Copiar `.env.production` como `.env`
- [ ] Editar `.env` con los valores correctos
- [ ] Verificar que `config/master.key` esté presente

### Deploy/Actualización
- [ ] Conectarse a EC2 via SSH
- [ ] Navegar al directorio del proyecto
- [ ] Ejecutar `./deploy.sh`
- [ ] Verificar que no hay errores en los logs
- [ ] Probar que la aplicación carga en el navegador

## Post-Deploy

### Verificación
- [ ] La aplicación carga en https://www.javidonoso.me
- [ ] SSL funciona correctamente (candado verde)
- [ ] Se pueden crear juegos
- [ ] Se pueden subir imágenes
- [ ] Las imágenes se suben a S3 correctamente
- [ ] La base de datos tiene las tablas correctas

### Monitoreo
- [ ] Los logs no muestran errores: `docker-compose logs web`
- [ ] Todos los servicios están corriendo: `docker-compose ps`
- [ ] El certificado SSL se renovará automáticamente

## Comandos de Verificación

```bash
# Ver estado de servicios
docker-compose ps

# Ver logs
docker-compose logs web

# Verificar base de datos
docker-compose exec web bin/rails db:migrate:status

# Probar consola de Rails
docker-compose exec web bin/rails console

# Verificar S3
docker-compose exec web bin/rails runner "puts ActiveStorage::Blob.service.bucket"

# Verificar desde navegador
curl -I https://www.javidonoso.me
```

## En caso de problemas

### La aplicación no carga
1. Verificar logs: `docker-compose logs web`
2. Verificar que DB esté corriendo: `docker-compose ps db`
3. Verificar variables de entorno: `cat .env`

### Problemas con SSL
1. Verificar logs de Caddy: `docker-compose logs caddy`
2. Verificar que el dominio apunte a la IP: `dig www.javidonoso.me`
3. Verificar puertos 80 y 443 en Security Group

### Problemas con S3
1. Verificar credenciales en Rails console
2. Verificar permisos IAM
3. Verificar nombre del bucket en `config/storage.yml`

## Rollback

Si algo sale mal:

```bash
# Volver a versión anterior
git checkout <commit-anterior>
./deploy.sh

# O detener todo
docker-compose down
```
