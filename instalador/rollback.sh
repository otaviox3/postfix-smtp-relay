#!/usr/bin/env bash
set -euo pipefail
BACKUP_DIR="${1:-}"
[[ -n "$BACKUP_DIR" ]] || { echo "Uso: sudo $0 /root/postfix-relay-backup-AAAA-MM-DD-HHMMSS"; exit 1; }
[[ -d "$BACKUP_DIR" ]] || { echo "Backup não encontrado: $BACKUP_DIR"; exit 1; }
[[ -f "$BACKUP_DIR/main.cf.bkp" ]] && cp -p "$BACKUP_DIR/main.cf.bkp" /etc/postfix/main.cf
[[ -f "$BACKUP_DIR/master.cf.bkp" ]] && cp -p "$BACKUP_DIR/master.cf.bkp" /etc/postfix/master.cf
systemctl restart postfix
systemctl status postfix -l --no-pager
