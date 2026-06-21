#!/bin/bash
# ============================================================
#  Brave Browser - Restaurar backup
# ============================================================

SOURCE="$HOME/.config/BraveSoftware/Brave-Browser"
BACKUP_DIR="$HOME/brave-backups"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ---- Verificações ----
if [ ! -d "$BACKUP_DIR" ]; then
    log "${RED}[ERRO] Pasta de backups não encontrada: $BACKUP_DIR${NC}"
    exit 1
fi

BACKUPS=($(ls -dt "$BACKUP_DIR"/Brave-Browser_* 2>/dev/null))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    log "${RED}[ERRO] Nenhum backup encontrado em $BACKUP_DIR${NC}"
    exit 1
fi

# ---- Verificar se o Brave está aberto ----
if pgrep -x "brave" > /dev/null; then
    echo -e "${RED}[AVISO] O Brave está aberto! Fecha-o antes de restaurar.${NC}"
    read -p "Fechar o Brave agora automaticamente? (s/n): " FECHAR
    if [[ "$FECHAR" =~ ^[Ss]$ ]]; then
        pkill -x brave
        sleep 2
        log "${YELLOW}[INFO] Brave encerrado.${NC}"
    else
        log "${RED}[CANCELADO] Fecha o Brave manualmente e corre o script novamente.${NC}"
        exit 1
    fi
fi

# ---- Listar backups disponíveis ----
echo ""
echo -e "${CYAN}=== Backups disponíveis ===${NC}"
echo ""

for i in "${!BACKUPS[@]}"; do
    DIR="${BACKUPS[$i]}"
    NOME=$(basename "$DIR")
    TAMANHO=$(du -sh "$DIR" 2>/dev/null | cut -f1)
    DATA=$(echo "$NOME" | sed 's/Brave-Browser_//' | sed 's/_/ /' | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\3\/\2\/\1/')
    echo -e "  ${GREEN}[$((i+1))]${NC} $NOME  ${YELLOW}($TAMANHO)${NC}  📅 $DATA"
done

echo ""
echo -e "  ${GREEN}[0]${NC} Cancelar"
echo ""

# ---- Escolha do utilizador ----
read -p "Escolhe o número do backup a restaurar: " ESCOLHA

if [[ "$ESCOLHA" == "0" || -z "$ESCOLHA" ]]; then
    log "${YELLOW}[CANCELADO] Nenhuma ação realizada.${NC}"
    exit 0
fi

if ! [[ "$ESCOLHA" =~ ^[0-9]+$ ]] || [ "$ESCOLHA" -gt "${#BACKUPS[@]}" ]; then
    log "${RED}[ERRO] Opção inválida.${NC}"
    exit 1
fi

BACKUP_ESCOLHIDO="${BACKUPS[$((ESCOLHA-1))]}"

echo ""
log "${YELLOW}[INFO] Backup selecionado: $(basename "$BACKUP_ESCOLHIDO")${NC}"
echo ""

# ---- Confirmação ----
read -p "Tens a certeza? O perfil atual será substituído. (s/n): " CONFIRMA
if [[ ! "$CONFIRMA" =~ ^[Ss]$ ]]; then
    log "${YELLOW}[CANCELADO] Nenhuma ação realizada.${NC}"
    exit 0
fi

# ---- Guardar perfil atual como segurança ----
if [ -d "$SOURCE" ]; then
    SAFETY="$BACKUP_DIR/Brave-Browser_antes_restore_$(date +%Y%m%d_%H%M%S)"
    log "${YELLOW}[SEGURANÇA] A guardar perfil atual em: $(basename "$SAFETY")${NC}"
    cp -r "$SOURCE" "$SAFETY"
fi

# ---- Restaurar ----
log "${YELLOW}[RESTORE] A restaurar perfil...${NC}"
rm -rf "$SOURCE"
cp -r "$BACKUP_ESCOLHIDO" "$SOURCE"

if [ $? -eq 0 ]; then
    echo ""
    log "${GREEN}[OK] Perfil restaurado com sucesso!${NC}"
    log "${GREEN}[OK] Podes abrir o Brave agora.${NC}"
else
    log "${RED}[ERRO] Falha ao restaurar! Tenta recuperar de: $(basename "$SAFETY")${NC}"
    exit 1
fi
