#!/usr/bin/env bash
set -e

echo "🚀 Instalador completo do Neovim + Lua + dependências"
echo "====================================================="

# Detectar distro
if [ -f /etc/debian_version ]; then
    PKG="sudo apt install -y"
    UPDATE="sudo apt update -y"
elif [ -f /etc/arch-release ]; then
    PKG="sudo pacman -S --noconfirm"
    UPDATE="sudo pacman -Sy"
elif [ -f /etc/fedora-release ]; then
    PKG="sudo dnf install -y"
    UPDATE="sudo dnf check-update || true"
else
    echo "⚠️ Distribuição não suportada automaticamente."
    echo "Instale manualmente: git, curl, wget, unzip, build-essential, node, python3, etc."
    exit 1
fi

# Atualizar pacotes
echo "🔄 Atualizando pacotes..."
$UPDATE

# Pacotes essenciais
echo "📦 Instalando dependências principais..."
$PKG git curl wget unzip build-essential pkg-config libssl-dev python3 python3-pip nodejs npm ripgrep fd-find

# Corrigir nome fd no Ubuntu
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

# -------------------------------------------------------
# Instalar Lua 5.4.7 manualmente (independente da distro)
# -------------------------------------------------------
LUA_VERSION="5.4.7"
LUA_DIR="/usr/local"
TMP_DIR=$(mktemp -d)

echo "🌙 Instalando Lua $LUA_VERSION a partir da fonte..."
cd "$TMP_DIR"
wget -q "https://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz"
tar xzf "lua-$LUA_VERSION.tar.gz"
cd "lua-$LUA_VERSION"
make linux test
sudo make install

echo "✅ Lua instalada em $LUA_DIR/bin/lua"
lua -v

# Instalar Luarocks
LUAROCKS_VERSION="3.11.0"
echo "📦 Instalando Luarocks $LUAROCKS_VERSION..."
cd "$TMP_DIR"
wget -q "https://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz"
tar xzf "luarocks-$LUAROCKS_VERSION.tar.gz"
cd "luarocks-$LUAROCKS_VERSION"
./configure --with-lua=/usr/local
make
sudo make install
luarocks --version

# -------------------------------------------------------
# Instalar Neovim
# -------------------------------------------------------
echo "🧩 Instalando Neovim 0.11.4..."
cd "$TMP_DIR"
wget -q https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo mv nvim-linux-x86_64 /opt/nvim
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# -------------------------------------------------------
# Instalar bindings e libs Lua úteis
# -------------------------------------------------------
echo "📚 Instalando bibliotecas Lua úteis..."
sudo luarocks install luasocket
sudo luarocks install luafilesystem
sudo luarocks install lpeg
sudo luarocks install luacheck
sudo luarocks install busted
sudo luarocks install argparse
sudo luarocks install --server=https://luarocks.org/manifests/johnnymorganz stylua

# -------------------------------------------------------
# Instalar módulos Python e Node para Neovim
# -------------------------------------------------------
echo "🐍 Instalando pynvim..."
pip3 install --user pynvim

echo "🧠 Instalando neovim (npm)..."
sudo npm install -g neovim

# -------------------------------------------------------
# PATH e limpeza
# -------------------------------------------------------
if ! echo "$PATH" | grep -q "/usr/local/bin"; then
    SHELL_RC="$HOME/.bashrc"
    if [ -n "$ZSH_VERSION" ]; then SHELL_RC="$HOME/.zshrc"; fi
    echo 'export PATH="$PATH:/usr/local/bin"' >> "$SHELL_RC"
    echo "✅ PATH atualizado em $SHELL_RC"
fi

rm -rf "$TMP_DIR"

echo ""
echo "🎉 Instalação concluída!"
echo "------------------------------------------------------"
echo "Testes recomendados:"
echo "  lua -v"
echo "  luarocks --version"
echo "  nvim --version"
echo "------------------------------------------------------"
echo "💡 Dica: use o plugin manager Lazy.nvim ou NvChad pra começar!"

