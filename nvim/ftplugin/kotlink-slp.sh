#!/usr/bin/env bash
set -Eeuo pipefail

REPO="Kotlin/kotlin-lsp"
ROOT="$HOME/.local/share/kotlin-lsp"
BIN="$HOME/.local/bin"
CURRENT="$ROOT/current"
RELEASES="https://raw.githubusercontent.com/$REPO/main/RELEASES.md"

log()  { printf '\033[1;34m[Kotlin LSP]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[ERRO]\033[0m %s\n' "$*" >&2; exit 1; }

for cmd in curl python3 tar sha256sum; do
    command -v "$cmd" >/dev/null || die "Dependência ausente: $cmd"
done

[[ "$(uname -s)" == Linux ]] || die "Este script requer Linux."
[[ "$(uname -m)" == x86_64 ]] || die "Arquitetura não suportada."

mkdir -p "$ROOT" "$BIN"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

log "A consultar releases oficiais..."

curl -fsSL "$RELEASES" -o "$TMP/releases.md" ||
    die "Não foi possível consultar o GitHub."

# Extrair a versão e o URL do arquivo standalone.
python3 - "$TMP/releases.md" "$TMP/release.env" <<'PY'
import re
import sys

source = open(sys.argv[1]).read()

version = re.search(r"^### v([^\s]+)", source, re.M)
if not version:
    raise SystemExit("Versão não encontrada.")

parts = source.split("Standalone Kotlin LSP Archive", 1)
if len(parts) < 2:
    raise SystemExit("Arquivo standalone não encontrado.")

section = parts[1].split("\n### v", 1)[0]

url = re.search(
    r"Download for Linux-x64.*?\((https://[^)]+)\)",
    section,
    re.S
)

if not url:
    raise SystemExit("Download Linux-x64 não encontrado.")

with open(sys.argv[2], "w") as f:
    f.write(f"VERSION={version.group(1)}\n")
    f.write(f"URL={url.group(1)}\n")
PY

source "$TMP/release.env"

log "Última versão: $VERSION"

TARGET="$ROOT/$VERSION"

# Verificar se já existe uma instalação funcional.
if [[ -x "$TARGET/bin/kotlin-lsp" ]]; then
    SERVER="$TARGET/bin/kotlin-lsp"
elif [[ -x "$TARGET/bin/intellij-server" ]]; then
    SERVER="$TARGET/bin/intellij-server"
else
    SERVER=""
fi

if [[ -z "$SERVER" ]]; then
    log "A descarregar versão $VERSION..."

    curl -fL "$URL" -o "$TMP/kotlin-lsp.tar.gz" ||
        die "Download falhou."

    # Verificar checksum publicado, quando disponível.
    EXPECTED=$(grep -iE "SHA-?256" "$TMP/releases.md" |
        grep -F "$URL" |
        grep -oE '[a-fA-F0-9]{64}' |
        head -n1 || true)

    if [[ -n "$EXPECTED" ]]; then
        ACTUAL=$(sha256sum "$TMP/kotlin-lsp.tar.gz" | cut -d' ' -f1)
        [[ "${ACTUAL,,}" == "${EXPECTED,,}" ]] ||
            die "Checksum inválido."
    else
        log "Checksum não publicado; a verificar integridade do arquivo."
    fi

    mkdir "$TMP/extracted"
    tar -tzf "$TMP/kotlin-lsp.tar.gz" >/dev/null ||
        die "Arquivo inválido."

    tar -xzf "$TMP/kotlin-lsp.tar.gz" -C "$TMP/extracted"

    NEW_SERVER=$(find "$TMP/extracted" -type f \
        \( -name kotlin-lsp -o -name intellij-server \) \
        -perm /111 -print -quit)

    [[ -n "$NEW_SERVER" ]] ||
        die "Launcher não encontrado no pacote."

    RELATIVE="${NEW_SERVER#"$TMP/extracted"/}"

    # Instalação temporária e atómica.
    STAGING="$ROOT/.staging-$VERSION"
    rm -rf "$STAGING"
    mkdir -p "$STAGING"

    cp -a "$TMP/extracted/." "$STAGING/"

    [[ -x "$STAGING/$RELATIVE" ]] ||
        die "Instalação incompleta."

    # Preservar a versão antiga.
    if [[ -d "$TARGET" ]]; then
        mv "$TARGET" "$ROOT/backup-$VERSION-$(date +%s)"
    fi

    mv "$STAGING" "$TARGET"
    SERVER="$TARGET/$RELATIVE"
fi

log "Versão instalada: $VERSION"
log "A preparar launcher..."

# Launcher estável para Neovim.
cat > "$BIN/kotlin-lsp" <<EOF
#!/usr/bin/env bash
exec "$SERVER" "\$@"
EOF

chmod +x "$BIN/kotlin-lsp"

# Verificar se o processo consegue arrancar.
log "A verificar o executável..."

VERSION_OUTPUT=$("$BIN/kotlin-lsp" --version 2>&1 || true)

if grep -qiE 'expired|will now close|fatal error' <<< "$VERSION_OUTPUT"; then
    die "A nova build não passou na verificação: $VERSION_OUTPUT"
fi

log "Kotlin LSP $VERSION pronto!"
log "A iniciar servidor..."

exec "$BIN/kotlin-lsp --version " "$@"

