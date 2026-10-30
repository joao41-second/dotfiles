
#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================

# HYPRLAND + HY3 UPDATE SEGURO

# ============================================================

PACMAN_CONF="/etc/pacman.conf"
HY3_REPO="https://github.com/outfoxxed/hy3.git"

TMPDIR=""

# Pacotes do stack Hyprland que podem estar em IgnorePkg.

HYPR_PACKAGES=(
hyprland
hyprutils
hyprlang
hyprcursor
hyprtoolkit
hyprgraphics
hyprland-guiutils
hyprlauncher
hyprpaper
hyprwire
aquamarine
xdg-desktop-portal-hyprland
)

# ============================================================

# CLEANUP

# ============================================================

cleanup() {
local exit_code=$?

```
if [ -n "${TMPDIR:-}" ] && [ -d "$TMPDIR" ]; then
    rm -rf "$TMPDIR"
fi

exit "$exit_code"
```

}

trap cleanup EXIT

# ============================================================

# ERROR

# ============================================================

error() {
echo
echo "============================================================"
echo " ERRO"
echo "============================================================"
echo
printf '%s\n' "$1"
echo
exit 1
}

# ============================================================

# VERIFICAR COMANDOS

# ============================================================

for cmd in pacman git sudo awk sed grep sort head tail; do
if ! command -v "$cmd" >/dev/null 2>&1; then
error "Comando não encontrado: $cmd"
fi
done

# ============================================================

# VERIFICAR HYPRLAND

# ============================================================

if ! pacman -Q hyprland >/dev/null 2>&1; then
error "Hyprland não está instalado."
fi

# ============================================================

# VERSÃO ATUAL

# ============================================================

CURRENT_HYPR="$(pacman -Q hyprland | awk '{print $2}')"
CURRENT_HYPR_BASE="${CURRENT_HYPR%-*}"

echo
echo "Hyprland atual : $CURRENT_HYPR"
echo

# ============================================================

# ATUALIZAR DATABASES

# ============================================================

echo "==> A atualizar bases do pacman..."

if ! sudo pacman -Sy; then
error "Falha ao atualizar as bases do pacman."
fi

echo

# ============================================================

# VERSÃO DISPONÍVEL

# ============================================================

AVAILABLE_HYPR="$(
pacman -Si hyprland 2>/dev/null |
awk -F': ' '$1 == "Version" {print $2; exit}'
)"

if [ -z "$AVAILABLE_HYPR" ]; then
error "Não foi possível determinar a versão disponível do Hyprland."
fi

AVAILABLE_HYPR_BASE="${AVAILABLE_HYPR%-*}"

echo "Hyprland disponível : $AVAILABLE_HYPR"
echo

# ============================================================

# VERIFICAR SE JÁ ESTÁ ATUALIZADO

# ============================================================

if [ "$CURRENT_HYPR" = "$AVAILABLE_HYPR" ]; then
echo "Hyprland já está atualizado."
exit 0
fi

echo "Atualização encontrada:"
echo
echo "Hyprland $CURRENT_HYPR_BASE -> $AVAILABLE_HYPR_BASE"
echo

# ============================================================

# DETERMINAR SÉRIE HYPRLAND

# ============================================================

HYPR_SERIES="$(
printf '%s\n' "$AVAILABLE_HYPR_BASE" |
cut -d. -f1-2
)"

EXACT_TAG="hl${AVAILABLE_HYPR_BASE}"

echo "Hyprland alvo : $AVAILABLE_HYPR_BASE"
echo "Série hy3     : $HYPR_SERIES.x"
echo "Tag preferida : $EXACT_TAG"
echo

# ============================================================

# CONSULTAR TAGS HY3

# ============================================================

echo "==> A consultar o repositório oficial do hy3..."
echo
echo "$HY3_REPO"
echo

HY3_TAGS="$(
git ls-remote --tags "$HY3_REPO" 2>/dev/null |
awk -F/ '{print $NF}' |
sed 's/^{}$//' |
grep -E "^hl${HYPR_SERIES}.[0-9]+(.[0-9]+)?$" |
sort -V -u
)"

if [ -z "$HY3_TAGS" ]; then
error "Não existe nenhuma tag hy3 compatível com a série $HYPR_SERIES.x.

Hyprland alvo:
$AVAILABLE_HYPR_BASE

O sistema NÃO será alterado."
fi

# ============================================================

# ESCOLHER TAG HY3

# ============================================================

if printf '%s\n' "$HY3_TAGS" | grep -Fxq "$EXACT_TAG"; then

```
HY3_TAG="$EXACT_TAG"
```

else

```
HY3_TAG="$(
    printf '%s\n' "$HY3_TAGS" |
    sort -V |
    tail -n 1
)"
```

fi

if [ -z "$HY3_TAG" ]; then
error "Não foi possível selecionar uma versão compatível do hy3."
fi

# ============================================================

# COMMIT HY3

# ============================================================

HY3_COMMIT="$(
git ls-remote --tags "$HY3_REPO" "refs/tags/$HY3_TAG" 2>/dev/null |
awk '{print $1}' |
head -n 1
)"

if [ -z "$HY3_COMMIT" ]; then
error "Não foi possível obter o commit da tag $HY3_TAG."
fi

# ============================================================

# RESULTADO DA COMPATIBILIDADE

# ============================================================

echo "============================================================"
echo " HY3 COMPATÍVEL"
echo "============================================================"
echo

echo "Hyprland atual : $CURRENT_HYPR"
echo "Hyprland novo  : $AVAILABLE_HYPR"
echo
echo "Hy3 selecionado: $HY3_TAG"
echo "Commit         : $HY3_COMMIT"
echo

if [ "$HY3_TAG" != "$EXACT_TAG" ]; then
echo "Aviso:"
echo
echo "Não existe a tag:"
echo "    $EXACT_TAG"
echo
echo "Será usada a última versão disponível da série:"
echo "    $HYPR_SERIES.x"
echo
fi

# ============================================================

# CRIAR TEMPORÁRIO

# ============================================================

TMPDIR="$(mktemp -d)"

TEMP_PACMAN_CONF="$TMPDIR/pacman.conf"

# ============================================================

# CRIAR PACMAN.CONF TEMPORÁRIO

# ============================================================

cp "$PACMAN_CONF" "$TEMP_PACMAN_CONF"

# ============================================================

# REMOVER APENAS HYPRLAND DO IGNOREPKG

#

# Não alteramos /etc/pacman.conf.

# O pacman será executado com --config "$TEMP_PACMAN_CONF".

# ============================================================

awk -v packages="${HYPR_PACKAGES[*]}" '
BEGIN {
count = split(packages, p, " ")

```
for (i = 1; i <= count; i++) {
    remove[p[i]] = 1
}
```

}

function clean_ignore(line,    prefix, value, n, a, i, result) {

```
prefix = line
sub(/=.*/, "=", prefix)

value = line
sub(/^[^=]*=/, "", value)

n = split(value, a, /[[:space:]]+/)

result = ""

for (i = 1; i <= n; i++) {

    if (a[i] == "")
        continue

    if (a[i] in remove)
        continue

    result = result " " a[i]
}

if (result == "") {
    print prefix
} else {
    print prefix result
}

next
```

}

/^[[:space:]]*IgnorePkg[[:space:]]*=/ {
clean_ignore($0)
}

{
print
}
' "$PACMAN_CONF" > "$TMPDIR/pacman.conf.new"

mv "$TMPDIR/pacman.conf.new" "$TEMP_PACMAN_CONF"

# ============================================================

# MOSTRAR IGNOREPKG ORIGINAL

# ============================================================

echo
echo "IgnorePkg original:"
echo

awk '
/^[[:space:]]*IgnorePkg[[:space:]]*=/ {
print
}
' "$PACMAN_CONF" || true

echo

echo "IgnorePkg usado durante a atualização:"
echo

awk '
/^[[:space:]]*IgnorePkg[[:space:]]*=/ {
print
}
' "$TEMP_PACMAN_CONF" || true

echo

# ============================================================

# CONFIRMAR

# ============================================================

read -r -p "Continuar com Hyprland $AVAILABLE_HYPR? [y/N] " ANSWER

if [[ ! "$ANSWER" =~ ^[Yy]$ ]]; then
echo
echo "Atualização cancelada."
exit 0
fi

# ============================================================

# ATUALIZAÇÃO

# ============================================================

echo
echo "============================================================"
echo " ATUALIZAÇÃO DO SISTEMA"
echo "============================================================"
echo

echo "A executar pacman com configuração temporária..."
echo
echo "O /etc/pacman.conf original NÃO será alterado."
echo

if ! sudo pacman --config "$TEMP_PACMAN_CONF" -Syu; then
error "O pacman falhou durante a atualização."
fi

# ============================================================

# VERIFICAR HYPRLAND

# ============================================================

FINAL_HYPR="$(pacman -Q hyprland | awk '{print $2}')"

echo
echo "============================================================"
echo " VERIFICAÇÃO FINAL"
echo "============================================================"
echo

echo "Esperado : $AVAILABLE_HYPR"
echo "Instalado: $FINAL_HYPR"
echo

if [ "$FINAL_HYPR" != "$AVAILABLE_HYPR" ]; then
error "O Hyprland instalado não corresponde à versão esperada."
fi

# ============================================================

# VERIFICAR IGNOREPKG ORIGINAL

# ============================================================

echo "IgnorePkg original continua intacto em:"
echo
echo "    $PACMAN_CONF"
echo

# ============================================================

# SUCESSO

# ============================================================

echo "============================================================"
echo " ATUALIZAÇÃO CONCLUÍDA"
echo "============================================================"
echo

echo "Hyprland:"
echo "    $FINAL_HYPR"
echo

echo "Hy3 compatível selecionado:"
echo "    $HY3_TAG"
echo

echo "O /etc/pacman.conf não foi modificado."
echo

