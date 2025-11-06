# Instrucciones para configurar AWS S3

Para agregar las credenciales de AWS S3 a tu aplicación Rails:

## 1. Editar las credenciales encriptadas

En tu máquina local, ejecuta:

```bash
EDITOR="nano" bin/rails credentials:edit
```

O si usas VS Code:
```bash
EDITOR="code --wait" bin/rails credentials:edit
```

## 2. Agregar las credenciales de AWS

Agrega la siguiente estructura al archivo que se abre:

```yaml
aws:
  access_key_id: TU_AWS_ACCESS_KEY_ID_AQUI
  secret_access_key: TU_AWS_SECRET_ACCESS_KEY_AQUI
```

## 3. Verificar la configuración de S3

El archivo `config/storage.yml` ya está configurado con:
- **Region**: us-east-2
- **Bucket**: bitacora-deportivo-prod

Si tu bucket o región son diferentes, actualiza `config/storage.yml`.

## 4. Permisos necesarios en AWS IAM

Tu usuario IAM necesita estos permisos en el bucket S3:
- s3:PutObject
- s3:GetObject
- s3:DeleteObject
- s3:ListBucket

Ejemplo de política IAM:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::bitacora-deportivo-prod/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::bitacora-deportivo-prod"
    }
  ]
}
```

## 5. Después de editar

Guarda y cierra el editor. Rails encriptará automáticamente tus credenciales.

**IMPORTANTE**: El archivo `config/master.key` NO debe subirse a git. Asegúrate de que esté en `.gitignore`.
