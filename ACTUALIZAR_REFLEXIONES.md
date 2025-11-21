# 🚀 Actualizar EC2 con Reflexiones

## Comandos para ejecutar en EC2

Conecta a tu servidor EC2 y ejecuta estos comandos en orden:

```bash
# 1. Conectarse a EC2
ssh -i tu-llave.pem ubuntu@tu-ip-ec2

# 2. Ir al directorio del proyecto
cd ~/bitacora-deportivo

# 3. Obtener los últimos cambios (incluyendo migración de reflexiones)
git pull

# 4. Ejecutar las migraciones (crear tabla reflections)
docker compose exec web bin/rails db:migrate

# 5. Reiniciar el servidor web para cargar los nuevos controladores y rutas
docker compose restart web

# 6. Verificar que todo esté corriendo
docker compose ps
```

## ✅ Lo que se actualizará:

1. **Nueva tabla en la base de datos**: `reflections`
   - Campos: name, reflection, timestamps
   - Active Storage para profile_photo

2. **Nuevo recurso completo**:
   - Modelo: `Reflection`
   - Controlador: `ReflectionsController`
   - 5 vistas: index, show, new, edit, _form

3. **Navbar actualizado**:
   - Nuevo link "Reflexiones"

4. **Nuevas rutas**:
   - `/reflections` - Ver todas las reflexiones
   - `/reflections/new` - Crear reflexión
   - `/reflections/:id` - Ver reflexión individual
   - Y todas las rutas RESTful

## 🔍 Verificación

Después de ejecutar los comandos, verifica que todo funcione:

```bash
# Ver logs para asegurarte que no hay errores
docker compose logs web --tail=50

# Probar desde el navegador
# https://www.javidonoso.me/reflections
```

## 📊 Resultado esperado de la migración:

```
== 20251121193010 CreateReflections: migrating ==
-- create_table(:reflections)
   -> 0.04s
== 20251121193010 CreateReflections: migrated (0.04s) ==
```

## ⏱️ Tiempo estimado:

- `git pull`: ~5 segundos
- `db:migrate`: ~5 segundos
- `restart web`: ~10 segundos
- **Total**: ~20 segundos

¡Eso es todo! La sección de Reflexiones estará disponible en producción. 🎉
