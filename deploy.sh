#!/bin/bash
# Script de deploy para EC2
# Ejecuta este script en tu instancia EC2 para desplegar/actualizar la aplicación

set -e  # Detener si hay errores

echo "🚀 Iniciando deploy de Bitácora Deportivo..."

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: docker-compose.yml no encontrado${NC}"
    echo "Asegúrate de estar en el directorio raíz del proyecto"
    exit 1
fi

# Verificar que existe .env
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Archivo .env no encontrado${NC}"
    echo "Copiando .env.production como .env..."
    cp .env.production .env
    echo -e "${YELLOW}⚠️  IMPORTANTE: Edita .env con tus valores antes de continuar${NC}"
    echo "Ejecuta: nano .env"
    exit 1
fi

echo -e "${GREEN}✓${NC} Verificaciones iniciales completadas"

# Obtener últimos cambios
echo ""
echo "📥 Obteniendo últimos cambios del repositorio..."
git pull origin develop || {
    echo -e "${YELLOW}⚠️  No se pudo hacer pull. Continuando...${NC}"
}

# Detener contenedores existentes
echo ""
echo "🛑 Deteniendo contenedores existentes..."
docker-compose down

# Construir nueva imagen (solo si hay cambios)
echo ""
echo "🔨 Construyendo imagen Docker..."
echo "💡 Tip: Esto puede tardar varios minutos la primera vez..."
echo "💡 Los builds siguientes serán más rápidos gracias al caché"

# Habilitar BuildKit para mejor caché
export DOCKER_BUILDKIT=1

docker-compose build web

# Levantar servicios
echo ""
echo "🚀 Levantando servicios..."
docker-compose up -d

# Esperar a que la base de datos esté lista
echo ""
echo "⏳ Esperando a que PostgreSQL esté listo..."
sleep 5

# Ejecutar migraciones
echo ""
echo "📊 Ejecutando migraciones de base de datos..."
docker-compose exec -T web bin/rails db:migrate || {
    echo -e "${YELLOW}⚠️  Error en migraciones. Intentando db:prepare...${NC}"
    docker-compose exec -T web bin/rails db:prepare
}

# Verificar estado
echo ""
echo "🔍 Verificando estado de los servicios..."
docker-compose ps

echo ""
echo -e "${GREEN}✅ Deploy completado exitosamente!${NC}"
echo ""
echo "📊 Para ver los logs:"
echo "   docker-compose logs -f web"
echo ""
echo "🌐 La aplicación debería estar disponible en:"
echo "   https://www.javidonoso.me"
echo ""
echo "🔧 Comandos útiles:"
echo "   docker-compose ps          # Ver estado de servicios"
echo "   docker-compose logs web    # Ver logs"
echo "   docker-compose restart web # Reiniciar aplicación"
echo ""
