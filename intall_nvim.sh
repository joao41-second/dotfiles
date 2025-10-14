#!/usr/bin/env bash

set -e

# 1. Baixar a versão mais recente (ou a que você indicou)
URL="https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
TMP_DIR=$(mktemp -d)

echo "🔽 Baixando Neovim..."
wget -q "$URL" -O "$TMP_DIR/nvim.tar.gz"

# 2. Extrair
echo "📦 Extraindo..."
tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"

# 3. Mover para /opt/nvim (requer sudo)
echo "🚚 Instalando em /opt/nvim..."
sudo rm -rf /opt/nvim
sudo mv "$TMP_DIR/nvim-linux-x86_64" /opt/nvim

# 4. Criar link simbólico (recomendado)
echo "🔗 Criando link simbólico..."
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# 5. Garantir que o PATH tenha /usr/local/bin (geralmente já tem)
#    Mas, por segurança, adiciona no shell se faltar
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    SHELL_RC="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ]; then SHELL_RC="$HOME/.zshrc"; fi

    echo 'export PATH="$PATH:/usr/local/bin"' >> "$SHELL_RC"
    echo "✅ PATH atualizado em $SHELL_RC"
fi

# 6. Limpar temporários
rm -rf "$TMP_DIR"

echo "✅ Neovim instalado com sucesso!"
echo "➡️ Execute: nvim --version"

