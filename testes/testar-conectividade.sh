#!/usr/bin/env bash
set -euo pipefail

SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"

echo "[INFO] Testando conectividade TCP em $SMTP_HOST:$SMTP_PORT"

if command -v nc >/dev/null 2>&1; then
  nc -vz -w 5 "$SMTP_HOST" "$SMTP_PORT"
else
  echo "[ERRO] nc não encontrado."
  exit 1
fi

echo "[OK] Conectividade TCP validada."
