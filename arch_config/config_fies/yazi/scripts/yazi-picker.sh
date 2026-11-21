#!/usr/bin/env bash
# Wrapper xdg-desktop-portal-termfilechooser (Yazi no Kitty)

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
debug="${6:-0}"

[ "$debug" = 1 ] && set -x

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

ya="$(command  -v yazi)" || { echo "Yazi não encontrado" >&2; exit 1; }



base="$HOME"
filename="$(basename -- "$path")"
extension=""
case "$filename" in
    *.*) extension="${filename##*.}" ;;
esac
extension="${extension,,}"

case "$extension" in
    3mf)          target="$base/Desktop/3mf" ;;
    stl)          target="$base/Desktop/stl" ;;
    png|jpg|jpeg) target="$base/Pictures" ;;
    *)            target="$base" ;;
esac
mkdir -p "$target"

tmp="$(mktemp)"
cwdfile="$(mktemp)"
placeholder=""

cleanup() {
    rm -f "$tmp" "$cwdfile"
    # Apaga o placeholder (a aplicação volta a criar o ficheiro real)
    [ -n "$placeholder" ] && rm -f "$placeholder"
}
trap cleanup EXIT

# Define o que o Yazi abre
case "$mode" in
    save-file|save-files)
        [ -z "$filename" ] && filename="sem_nome"
        placeholder="$target/$filename"
        if [ -e "$placeholder" ]; then
            placeholder=""            # já existe: não o apagar no fim
            start="$target/$filename"
        else
            printf '%s\n' "Seleciona este ficheiro com Enter para guardar aqui." > "$placeholder"
            start="$placeholder"
        fi
        ;;
    *)
        if [ -d "$path" ]; then
            start="$path"
        elif [ -n "$path" ] && [ -d "$(dirname -- "$path")" ]; then
            start="$(dirname -- "$path")"
        else
            start="$target"
        fi
        ;;
esac

kitty --single-instance=no \
    --class=filechooser \
    --class yazi-float \
    --title="Selecionar - ${extension:-ficheiro}" \
    "$ya" "$start" \
    --chooser-file="$tmp" \
    --cwd-file="$cwdfile"

: > "$out"

case "$mode" in
    dir|dirs|save-dir)
        if [ -s "$tmp" ]; then cat "$tmp" > "$out"
        elif [ -s "$cwdfile" ]; then cat "$cwdfile" > "$out"
        fi
        ;;
    *)
        [ -s "$tmp" ] && cat "$tmp" > "$out"
        ;;
esac

exit 0
