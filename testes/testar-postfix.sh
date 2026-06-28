#!/usr/bin/env bash
set -euo pipefail

MAIL_FROM="${MAIL_FROM:-naoresponda@exemplo.com}"
TEST_TO="${TEST_TO:-destino@exemplo.com}"

echo "[INFO] Testando envio local via Postfix"

if command -v s-nail >/dev/null 2>&1; then
  MAIL_CMD="s-nail"
elif command -v mailx >/dev/null 2>&1; then
  MAIL_CMD="mailx"
else
  echo "[ERRO] s-nail/mailx não encontrado."
  exit 1
fi

echo "Teste via Postfix local em $(hostname) - $(date)" | \
"$MAIL_CMD" -r "$MAIL_FROM" -s "Teste Postfix Relay - $(hostname)" "$TEST_TO"

echo "[INFO] Últimos logs:"
journalctl -u postfix -n 40 --no-pager || true
