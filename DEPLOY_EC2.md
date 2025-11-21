# 🚀 Guía de Deploy en EC2 con HTTPS

## ✅ Cambios Realizados

Se ha restaurado la configuración de producción con HTTPS:

### Archivos Actualizados:

1. **Caddyfile** - Ahora usa HTTPS automático con Let's Encrypt
   - SSL automático para javidonoso.me y www.javidonoso.me
   - Headers de seguridad configurados
   - Compresión habilitada

2. **config/environments/production.rb**
   - `force_ssl = true` (fuerza HTTPS)
   - Dominios configurados

3. **README.md** - Actualizado con documentación completa

### Archivos Eliminados (limpieza):
- `Caddyfile.http` (ya no necesario)
- `Caddyfile.backup` (ya no necesario)
- `Caddyfile.local` (desarrollo local)
- `.env.s3` (ejemplo duplicado)
- `docker-compose.local.yml` (no usado)
- `ARCHIVOS_DEPLOY.md` (documentación temporal)
- `AWS_S3_SETUP.md` (documentación temporal)
- `DEPLOY.md` (documentación temporal)
- `DEPLOY_CHECKLIST.md` (documentación temporal)
- `deploy.sh` (script temporal)
- `setup-ec2.sh` (script temporal)

## 🔧 Comandos para EC2

### 1. Conectarse a EC2

```bash
ssh -i tu-llave.pem ubuntu@tu-ip-ec2
cd ~/bitacora-deportivo
```

### 2. Actualizar el código

```bash
# Obtener los últimos cambios (incluyendo el nuevo Caddyfile)
git pull
```

### 3. Reiniciar Caddy para aplicar SSL

```bash
# Reconstruir y reiniciar Caddy con la nueva configuración HTTPS
docker compose restart caddy

# Ver logs de Caddy para verificar que obtenga el certificado SSL
docker compose logs -f caddy
```

**Deberías ver algo como:**
```
caddy    | {"level":"info","msg":"certificate obtained successfully"}
caddy    | {"level":"info","msg":"serving initial configuration"}
```

### 4. Verificar que funciona

```bash
# Desde EC2
curl -I https://www.javidonoso.me

# Deberías ver:
# HTTP/2 200
# strict-transport-security: max-age=31536000;
```

### 5. Si hay problemas con el certificado

Si Caddy no puede obtener el certificado (por ejemplo, si el dominio no está apuntando correctamente):

```bash
# Ver logs detallados
docker compose logs caddy

# Forzar renovación de certificados
docker compose stop caddy
docker compose rm -f caddy
docker volume rm bitacora-deportivo_caddy_data || true
docker compose up -d caddy

# Ver logs en tiempo real
docker compose logs -f caddy
```

## 🔍 Verificación

### Desde tu navegador:

1. Visita: https://www.javidonoso.me
2. Deberías ver el **candado verde** en la barra de direcciones
3. El certificado debería ser válido y emitido por Let's Encrypt

### Verificar redirección HTTP → HTTPS:

1. Visita: http://www.javidonoso.me
2. Debería redirigir automáticamente a: https://www.javidonoso.me

## 📊 Monitoreo

```bash
# Ver estado de todos los servicios
docker compose ps

# Ver logs de Caddy
docker compose logs -f caddy

# Ver logs de la aplicación Rails
docker compose logs -f web

# Ver uso de recursos
docker stats
```

## ⚠️ Importante

- **Let's Encrypt tiene un límite de 5 certificados por dominio por semana**
- Los certificados se renuevan automáticamente cada 90 días
- No requiere intervención manual después de la configuración inicial
- Caddy maneja todo el proceso de obtención y renovación

## 🆘 Troubleshooting

### Si Caddy no puede obtener el certificado:

1. **Verificar que el dominio apunta a la IP correcta:**
   ```bash
   dig www.javidonoso.me
   dig javidonoso.me
   ```

2. **Verificar que los puertos 80 y 443 están abiertos en Security Group:**
   - Puerto 80: Necesario para el challenge de Let's Encrypt
   - Puerto 443: HTTPS

3. **Ver logs de Caddy:**
   ```bash
   docker compose logs caddy | grep -i error
   ```

### Si llegas al límite de Let's Encrypt:

- Espera 7 días desde el último intento
- No hagas múltiples intentos seguidos
- Usa la configuración HTTP temporal si necesitas la app funcionando

## ✅ Checklist Final

- [ ] Código actualizado con `git pull`
- [ ] Caddy reiniciado con `docker compose restart caddy`
- [ ] Certificado SSL obtenido (verificar en logs)
- [ ] Sitio accesible por HTTPS con candado verde
- [ ] Redirección HTTP → HTTPS funciona
- [ ] Todos los servicios corriendo: `docker compose ps`
- [ ] No hay errores en logs: `docker compose logs`

¡Listo! Tu aplicación ahora debería estar funcionando con HTTPS completo. 🎉
