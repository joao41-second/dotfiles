#!/bin/bash

# Script para instalar Neovim 0.10.1
# Autor: Script de instalação automática
# Data: 2025-10-14

set -e  # Sai em caso de erro

NVIM_VERSION="0.10.1"
INSTALL_DIR="/usr/local"

echo "=========================================="
echo "Instalando Neovim ${NVIM_VERSION}"
echo "=========================================="

# Detectar sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Sistema: Linux detectado"
    
    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    echo "Baixando Neovim ${NVIM_VERSION}..."
    wget "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz"
    
    echo "Extraindo arquivos..."
    tar xzf nvim-linux64.tar.gz
    
    echo "Instalando Neovim..."
    sudo rm -rf ${INSTALL_DIR}/nvim-linux64
    sudo mv nvim-linux64 ${INSTALL_DIR}/
    
    # Criar link simbólico
    sudo ln -sf ${INSTALL_DIR}/nvim-linux64/bin/nvim /usr/local/bin/nvim
    
    # Limpar arquivos temporários
    cd -
    rm -rf "$TEMP_DIR"
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Sistema: macOS detectado"
    
    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    echo "Baixando Neovim ${NVIM_VERSION}..."
    curl -LO "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-macos-x86_64.tar.gz"
    
    echo "Extraindo arquivos..."
    tar xzf nvim-macos-x86_64.tar.gz
    
    echo "Instalando Neovim..."
    sudo rm -rf ${INSTALL_DIR}/nvim-macos-x86_64
    sudo mv nvim-macos-x86_64 ${INSTALL_DIR}/
    
    # Criar link simbólico
    sudo ln -sf ${INSTALL_DIR}/nvim-macos-x86_64/bin/nvim /usr/local/bin/nvim
    
    # Limpar arquivos temporários
    cd -
    rm -rf "$TEMP_DIR"
    
else
    echo "Sistema operacional não suportado: $OSTYPE"
    exit 1
fi

echo ""
echo "=========================================="
echo "Instalação concluída com sucesso!"
echo "=========================================="
echo ""
echo "Verificando versão instalada:"
nvim --version | head -n 1

echo ""
echo "Para usar o Neovim, execute: nvim"
