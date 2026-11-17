#!/usr/bin/env bash

# Wrapper xdg-desktop-portal-termfilechooser
# Yazi dentro do Kitty
# Destinos automáticos por extensão

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
debug="${6:-0}"

set -e

if [ "$debug" = 1 ]; then
    set -x
fi

# Determina o modo do seletor
case "$multiple$directory$save" in
    000) mode=file ;;
    100) mode=files ;;
    010) mode=dir ;;
    001) mode=save-file ;;
    110) mode=dirs ;;
    101) mode=save-files ;;
    011|111) mode=save-dir ;;
    *) echo "Parâmetros inválidos" >&2; exit 1 ;;
esac

# Localiza Yazi
ya="$(command -v yazi)" || {
    echo "Erro: Yazi não encontrado." >&2
    exit 1
}

# Diretório base
downloads="$HOME"

# Identifica a extensão do ficheiro
filename="$(basename -- "$path")"
extension="${filename##*.}"
extension="$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')"

# Define a pasta conforme a extensão
case "$extension" in
    3mf)
        target="$downloads/Desktop/3mf"
        ;;
    stl)
        target="$downloads/Desktop/stl"
        ;;
    png|jpg|jpeg)
        target="$downloads/Pictures"
        ;;
    *)
        target="$downloads"
        ;;
esac

# Cria a pasta se não existir
mkdir -p "$target"

# Define pasta inicial
if [ "$save" = 1 ]; then
    start_dir="$target"
elif [ -d "$path" ]; then
    start_dir="$path"
elif [ -n "$path" ] && [ -d "$(dirname -- "$path")" ]; then
    start_dir="$(dirname -- "$path")"
else
    start_dir="$target"
fi

# Ficheiro de saída
touch "$out"

# Ficheiro temporário
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Abre Yazi no Kitty
kitty \
    --class=filechooser \
    --title="Guardar ficheiro - $extension" \
    -- "$ya" "$start_dir" \
    --chooser-file="$tmp"

# Cancelamento
if [ ! -s "$tmp" ]; then
    exit 0
fi

# Devolve seleção ao portal
cat "$tmp" > "$out"

