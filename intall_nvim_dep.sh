#!/usr/bin/env bash
set -e

echo "🔧 Iniciando instalação das dependências do Neovim e Lua..."

# Detectar distro
if [ -f /etc/debian_version ]; then
    PKG="sudo apt install -y"
elif [ -f /etc/arch-release ]; then
    PKG="sudo pacman -S --noconfirm"
elif [ -f /etc/fedora-release ]; then
    PKG="sudo dnf install -y"
else
    echo "⚠️ Distribuição não suportada automaticamente. Instale manualmente as dependências."
    exit 1
fi

# Atualizar pacotes
echo "🔄 Atualizando repositórios..."
if [[ "$PKG" == *apt* ]]; then
    sudo apt update -y
fi

# Pacotes base para Neovim e desenvolvimento
echo "📦 Instalando pacotes base..."
$PKG git curl wget unzip build-essential pkg-config libssl-dev

# Dependências do Neovim (para LSP, etc.)
echo "🧩 Instalando dependências do Neovim..."
$PKG ripgrep fd-find python3 python3-pip nodejs npm

# Dependências de Lua
echo "🌙 Instalando Lua e Luarocks..."
if [[ "$PKG" == *apt* ]]; then
    $PKG lua5.4 luarocks
elif [[ "$PKG" == *pacman* ]]; then
    $PKG lua luarocks
elif [[ "$PKG" == *dnf* ]]; then
    $PKG lua lua-devel luarocks
fi

# Ferramentas adicionais
echo "🧰 Instalando ferramentas extras..."
sudo npm install -g neovim
pip3 install --user pynvim
sudo luarocks install luasocket || true
sudo luarocks install luafilesystem || true
sudo luarocks install lpeg || true
sudo luarocks install busted || true
sudo luarocks install luacheck || true
sudo luarocks install lanes || true
sudo luarocks install argparse || true

# Formatter Lua (opcional, muito útil)
sudo luarocks install --server=https://luarocks.org/manifests/johnnymorganz stylua || true

# Criar atalhos fd/ripgrep se necessário (Ubuntu renomeia fd-find → fdfind)
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "✅ Tudo pronto!"
echo ""
echo "Agora você já pode:"
echo "  - Rodar 'nvim' para abrir o Neovim"
echo "  - Usar LSPs via Mason/Lazy.nvim"
echo "  - Usar Lua e Luarocks normalmente"
echo ""
echo "➡️ Teste com: lua -v && nvim --version"

