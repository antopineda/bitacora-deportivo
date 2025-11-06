#!/bin/bash
# Script de configuración inicial para EC2
# Ejecuta este script la PRIMERA VEZ que configures el servidor

set -e

echo "🔧 Configuración inicial de EC2 para Bitácora Deportivo"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias básicas
echo ""
echo "📦 Instalando dependencias básicas..."
sudo apt install -y curl git htop

# Instalar Docker
echo ""
echo "🐳 Instalando Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo -e "${GREEN}✓ Docker instalado${NC}"
else
    echo -e "${GREEN}✓ Docker ya está instalado${NC}"
fi

# Instalar Docker Compose
echo ""
echo "🐳 Instalando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose
    echo -e "${GREEN}✓ Docker Compose instalado${NC}"
else
    echo -e "${GREEN}✓ Docker Compose ya está instalado${NC}"
fi

# Configurar firewall (opcional)
echo ""
echo "🔥 Configurando firewall UFW..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 22/tcp   # SSH
    sudo ufw allow 80/tcp   # HTTP
    sudo ufw allow 443/tcp  # HTTPS
    echo -e "${YELLOW}⚠️  Para habilitar el firewall ejecuta: sudo ufw enable${NC}"
else
    echo "UFW no está instalado. Saltando configuración de firewall..."
fi

echo ""
echo -e "${GREEN}✅ Configuración inicial completada${NC}"
echo ""
echo "📝 Próximos pasos:"
echo ""
echo "1. Cierra sesión y vuelve a conectarte para que Docker funcione sin sudo:"
echo "   exit"
echo ""
echo "2. Clona el repositorio:"
echo "   git clone https://github.com/antopineda/bitacora-deportivo.git"
echo "   cd bitacora-deportivo"
echo ""
echo "3. Configura las variables de entorno:"
echo "   cp .env.production .env"
echo "   nano .env"
echo ""
echo "4. Ejecuta el deploy:"
echo "   ./deploy.sh"
echo ""
