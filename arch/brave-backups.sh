#!/bin/bash
# ============================================================
#  Brave Browser - Backup automático a cada 15 minutos
# ============================================================

SOURCE="$HOME/.config/BraveSoftware/Brave-Browser"
BACKUP_DIR="$HOME/brave-backups"
MAX_BACKUPS=10        # número máximo de backups a guardar
INTERVAL=$((15 * 60)) # 15 minutos em segundos

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

fazer_backup() {
    if [ ! -d "$SOURCE" ]; then
        log "${RED}[ERRO] Diretório do Brave não encontrado: $SOURCE${NC}"
        return 1
    fi

    mkdir -p "$BACKUP_DIR"

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    DEST="$BACKUP_DIR/Brave-Browser_$TIMESTAMP"

    log "${YELLOW}[BACKUP] A copiar perfil...${NC}"
    cp -r "$SOURCE" "$DEST"

    if [ $? -eq 0 ]; then
        SIZE=$(du -sh "$DEST" | cut -f1)
        log "${GREEN}[OK] Backup criado: $DEST ($SIZE)${NC}"
    else
        log "${RED}[ERRO] Falha ao criar backup!${NC}"
        return 1
    fi

    # Apagar backups mais antigos se passar o limite
    TOTAL=$(ls -d "$BACKUP_DIR"/Brave-Browser_* 2>/dev/null | wc -l)
    if [ "$TOTAL" -gt "$MAX_BACKUPS" ]; then
        EXCESSO=$((TOTAL - MAX_BACKUPS))
        log "${YELLOW}[LIMPEZA] A remover $EXCESSO backup(s) antigo(s)...${NC}"
        ls -dt "$BACKUP_DIR"/Brave-Browser_* | tail -n "$EXCESSO" | xargs rm -rf
    fi
}

# ---- Início ----
log "${GREEN}=== Brave Backup iniciado ===${NC}"
log "Origem  : $SOURCE"
log "Destino : $BACKUP_DIR"
log "Intervalo: 15 minutos | Máx. backups: $MAX_BACKUPS"
echo ""

# Primeiro backup imediato
fazer_backup

# Loop a cada 15 minutos
while true; do
    log "A aguardar 15 minutos..."
    sleep "$INTERVAL"
    fazer_backup
done
