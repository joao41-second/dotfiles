

#!/bin/bash

# Script de atualização para Arch Linux
# Autor: Você
# Data: $(date)

echo "=== Início do script de atualização ==="

# Verifica se o usuário é root ou se está usando sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Este script deve ser executado como root ou com sudo."
    exit 1
fi

# Atualiza os repositórios
echo "Atualizando listas de pacotes..."
sudo pacman -Syu --noconfirm

echo "Atualizando o hypreland..."
 hyprpm update  
 hyprpm reload
 htprpm enable hy3

pção opcional: Atualiza o kernel (se quiser)
echo "Atualizando kernel (opcional)..."
sudo pacman -Syu --noconfirm linux linux-headers

# Verifica se houve atualizações
if [ $? -eq 0 ]; then
    echo "✅ Atualizações realizadas com sucesso!"
    echo "Sugestão: Faça um reboot para garantir que todos os módulos estão carregados."
else
    echo "❌ Falha ao atualizar os pacotes."
    exit 1
fi
