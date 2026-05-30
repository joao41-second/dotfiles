#!/bin/bash

PATHS="$(pwd)"

echo "$PATHS"

mkdir -p ~/.config

configs=(
    hypr
    kitty
    yazi
    blueman
)

for cfg in "${configs[@]}"; do
    target="$HOME/.config/$cfg"

    # remove symlink antigo
    [ -L "$target" ] && rm "$target"

    # avisa se existir pasta real
    if [ -d "$target" ]; then
        echo "Diretório já existe: $target"
        continue
    fi

    ln -s "$PATHS/$cfg" "$target"

    echo "Linked $cfg"
done
