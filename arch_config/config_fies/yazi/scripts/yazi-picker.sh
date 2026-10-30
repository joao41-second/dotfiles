#!/bin/bash

# Pastas configuráveis (podes alterar estes caminhos)
DIR_IMG="${DIR_IMG:-$HOME/Pictures}"
DIR_STL="${DIR_STL:-$HOME/Desktop/stl}"
DIR_DOC="${DIR_DOC:-$HOME/Documents}"
DIR_DOWNLOADS="${DIR_DOWNLOADS:-$HOME/Downloads}"

# Escolhe uma pasta existente, usando a HOME como alternativa
existing_dir() {
    if [ -d "$1" ]; then
        printf '%s\n' "$1"
    elif [ -d "$HOME" ]; then
        printf '%s\n' "$HOME"
    else
        printf '%s\n' "$PWD"
    fi
}

# Identifica a categoria pelo tipo de ficheiro ou pelo nome recebido
get_start_dir() {
    local input="${1:-}"
    local ext=""

    # Se for uma pasta, abre diretamente essa pasta
    if [ -n "$input" ] && [ -d "$input" ]; then
        printf '%s\n' "$input"
        return
    fi

    # Se não houver argumento, usa a pasta atual
    if [ -z "$input" ]; then
        printf '%s\n' "$PWD"
        return
    fi

    # Aceita categorias diretamente: img, stl, doc, download
    case "${input,,}" in
        img|imagem|imagens|image|images)
            existing_dir "$DIR_IMG"
            return
            ;;
        stl|3d|modelo3d|modelos3d|model)
            existing_dir "$DIR_STL"
            return
            ;;
        doc|docs|documento|documentos|document)
            existing_dir "$DIR_DOC"
            return
            ;;
        download|downloads)
            existing_dir "$DIR_DOWNLOADS"
            return
            ;;
    esac

    # Caso seja um caminho de ficheiro, identifica a extensão
    ext="${input##*/}"
    if [[ "$ext" == *.* ]]; then
        ext="${ext##*.}"
        ext="${ext,,}"
    else
        ext=""
    fi

    case "$ext" in
        png|jpg|jpeg|webp|gif|bmp|tif|tiff|svg|avif|heic)
            existing_dir "$DIR_IMG"
            ;;
        stl|obj|3mf|step|stp|amf|ply|fbx|gltf|glb|blend|3ds)
            existing_dir "$DIR_STL"
            ;;
        pdf|txt|odt|doc|docx|rtf|md|csv|xls|xlsx|ods)
            existing_dir "$DIR_DOC"
            ;;
        *)
            existing_dir "$DIR_DOWNLOADS"
            ;;
    esac
}

# Localiza o Yazi
ya=$(command -v yazi)

if [ -z "$ya" ]; then
    echo "Erro: yazi não encontrado." >&2
    exit 1
fi

# O primeiro argumento define a categoria ou a pasta inicial
start_dir=$(get_start_dir "${1:-}")

# Abre o seletor dentro do Kitty
file=$(kitty sh -c '
    ya=$(command -v yazi) || exit 1
    shift
    tmp=$(mktemp -t yazi-picker.XXXXXX) || exit 1
    trap '\''rm -f "$tmp"'\'' EXIT

    "$ya" "$1" --chooser-file="$tmp"
    status=$?

    if [ -s "$tmp" ]; then
        cat "$tmp"
    fi

    exit "$status"
' sh "$start_dir")

# Devolve os caminhos selecionados
if [ -n "$file" ]; then
    printf '%s\n' "$file"
fi
