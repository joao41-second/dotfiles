#!/usr/bin/env bash
set -euo pipefail

# Instala o neovim "latest" do GitHub (neovim/neovim)
# Suporta: nvim-linux64.tar.gz, nvim-linux64.deb, macos builds, linux-arm64
# Requisitos: curl, jq, tar, sha256sum (opcional), sudo (para instalação em /usr/local)

REPO="neovim/neovim"
API="https://api.github.com/repos/${REPO}/releases/latest"
TMPDIR="$(mktemp -d /tmp/nvim-install.XXXX)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Buscando release mais recente do ${REPO}..."
release_json="$(curl -fsSL "$API")"

tag_name="$(printf '%s' "$release_json" | jq -r '.tag_name')"
echo "Release encontrada: $tag_name"

# detect arch/os
uname_s="$(uname -s)"
uname_m="$(uname -m)"

echo "Detectando plataforma: $uname_s $uname_m"

# mapeamento simples de asset name esperado
asset_pattern=""
case "$uname_s" in
  Linux)
    case "$uname_m" in
      x86_64|amd64) asset_pattern="nvim-linux64.tar.gz|nvim-linux-x86_64.tar.gz|nvim-linux64.deb" ;;
      aarch64|arm64) asset_pattern="nvim-linux64.tar.gz|nvim-linux-arm64.tar.gz" ;; # some builds use linux64 for arm64
      *)
        echo "Arquitetura $uname_m não detectada automaticamente. Por favor edite o script para suportar."
        exit 1
        ;;
    esac
    ;;
  Darwin)
    # macOS: prefer nvim-macos.tar.gz or nvim-macos.zip
    asset_pattern="nvim-macos.tar.gz|nvim-macos.zip"
    ;;
  *)
    echo "SO $uname_s não suportado por este script."
    exit 1
    ;;
esac

# find asset URL
asset_url="$(printf '%s' "$release_json" \
  | jq -r --arg pat "$asset_pattern" '.assets[] | select( (.name | test($pat)) ) | .browser_download_url' \
  | head -n1)"

if [ -z "$asset_url" ]; then
  echo "Nao consegui encontrar asset compatível automaticamente. Aqui estão os assets disponíveis:"
  printf '%s\n' "$release_json" | jq -r '.assets[].name'
  exit 1
fi

asset_name="$(basename "$asset_url")"
echo "Asset selecionado: $asset_name"
echo "URL: $asset_url"

cd "$TMPDIR"

# try also to fetch checksum file if present
# common checksum asset name: <asset>.sha256 or nvim-<tag>.sha256sum
checksum_url="$(printf '%s' "$release_json" \
  | jq -r '.assets[] | .browser_download_url as $u | .name as $n | select( ($n | test(".sha256|.sha256sum|sha256sum")) ) | $u' \
  | head -n1 || true)"

if [ -n "$checksum_url" ]; then
  echo "Checksum disponível: $checksum_url"
  curl -fSL "$checksum_url" -o checksum.txt
else
  echo "Nenhuma checksum encontrada entre os assets. Procedendo sem verificação automática."
fi

echo "Baixando asset..."
curl -fL --progress-bar "$asset_url" -o "$asset_name"

# If checksum present, try to verify
if [ -f checksum.txt ]; then
  echo "Tentando verificar checksum..."
  # checksum file might contain lines like: "<sha256>  <filename>"
  # try to match for our filename
  if grep -q "$asset_name" checksum.txt; then
    grep "$asset_name" checksum.txt | awk '{print $1}' > expected.sha256
  else
    # if checksum file is a single hash, use it
    awk 'NR==1{print $1}' checksum.txt > expected.sha256
  fi
  expected="$(cat expected.sha256)"
  actual="$(sha256sum "$asset_name" | awk '{print $1}')"
  if [ "$expected" = "$actual" ]; then
    echo "Checksum OK."
  else
    echo "AVISO: checksum falhou! esperado=$expected atual=$actual"
    echo "Abortando para evitar instalar binário corrompido."
    exit 1
  fi
fi

# Install depending on asset type
if [[ "$asset_name" =~ \.tar\.gz$ ]] || [[ "$asset_name" =~ \.zip$ ]]; then
  echo "Extraindo e instalando (tar/zip)..."
  mkdir -p extracted
  if [[ "$asset_name" =~ \.tar\.gz$ ]]; then
    tar -xzf "$asset_name" -C extracted
  else
    unzip -q "$asset_name" -d extracted
  fi

  # Expecting structure like ./nvim-linux64/bin/nvim
  nvim_bin="$(find extracted -type f -path '*/bin/nvim' -print -quit || true)"
  if [ -z "$nvim_bin" ]; then
    echo "Nao encontrei binario 'nvim' dentro do archive. Conteudo de extracted:"
    find extracted -maxdepth 3 -type f -ls
    exit 1
  fi

  echo "Copiando binario para /usr/local (precisa de sudo)..."
  sudo mkdir -p /usr/local/bin /usr/local/share/nvim
  sudo cp -a "$(dirname "$nvim_bin")/." /usr/local/bin/ || true
  # Better: copy full tree preserving layout
  # find the top-level dir inside extracted (like nvim-linux64) and copy its contents
  topdir="$(find extracted -maxdepth 1 -mindepth 1 -type d | head -n1)"
  if [ -n "$topdir" ]; then
    sudo cp -r "$topdir"/* /usr/local/
  fi

  echo "Instalação por tar.gz concluída. Verifique com: /usr/local/bin/nvim --version"
elif [[ "$asset_name" =~ \.deb$ ]]; then
  echo "Instalando pacote .deb..."
  sudo apt update || true
  sudo apt install -y ./ "$asset_name" 2>/dev/null || {
    # fallback para dpkg + apt-get -f install
    sudo dpkg -i "$asset_name" || true
    sudo apt -f install -y
  }
  echo "Instalação .deb concluída. Verifique com: nvim --version"
else
  echo "Tipo de asset não tratado: $asset_name"
  exit 1
fi

echo ""
echo "OK — Neovim $tag_name instalado (ou atualizado). Verifique executando: nvim --version"

if [ -f /usr/local/bin/nvim ]; then
  echo "Substituindo binário antigo (para uso global)..."
  sudo cp /usr/local/bin/nvim /usr/bin/nvim
  sudo chmod 755 /usr/bin/nvim
  echo "Neovim atualizado globalmente!"
else
  echo "Erro: binário /usr/local/bin/nvim não encontrado."
fi
