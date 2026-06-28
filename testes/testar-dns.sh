#!/usr/bin/env bash
set -euo pipefail

SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"

echo "[INFO] Testando DNS para: $SMTP_HOST"

if getent hosts "$SMTP_HOST"; then
  echo "[OK] DNS resolvido com sucesso."
else
  echo "[ERRO] Falha ao resolver DNS para $SMTP_HOST."
  exit 1
fi
