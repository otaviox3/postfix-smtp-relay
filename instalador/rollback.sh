#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${1:-}"

if [[ -z "$BACKUP_DIR" ]]; then
  echo "Uso: sudo $0 /root/postfix-relay-backup-AAAA-MM-DD-HHMMSS"
  exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "Diretório de backup não encontrado: $BACKUP_DIR"
  exit 1
fi

[[ -f "$BACKUP_DIR/main.cf.bkp" ]] && cp -p "$BACKUP_DIR/main.cf.bkp" /etc/postfix/main.cf
[[ -f "$BACKUP_DIR/master.cf.bkp" ]] && cp -p "$BACKUP_DIR/master.cf.bkp" /etc/postfix/master.cf
[[ -f "$BACKUP_DIR/sasl_passwd.bkp" ]] && cp -p "$BACKUP_DIR/sasl_passwd.bkp" /etc/postfix/sasl_passwd
[[ -f "$BACKUP_DIR/sasl_passwd.db.bkp" ]] && cp -p "$BACKUP_DIR/sasl_passwd.db.bkp" /etc/postfix/sasl_passwd.db

systemctl restart postfix
systemctl status postfix -l --no-pager
