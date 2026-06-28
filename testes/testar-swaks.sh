#!/usr/bin/env bash
set -euo pipefail

SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"
SMTP_USER="${SMTP_USER:-naoresponda@exemplo.com}"
SMTP_PASS="${SMTP_PASS:-SENHA_AQUI}"
MAIL_FROM="${MAIL_FROM:-naoresponda@exemplo.com}"
TEST_TO="${TEST_TO:-destino@exemplo.com}"
TLS_MODE="${TLS_MODE:-starttls}"
HELO="$(hostname -f 2>/dev/null || hostname)"

if ! command -v swaks >/dev/null 2>&1; then
  echo "[ERRO] swaks não encontrado."
  exit 1
fi

echo "[INFO] Testando SMTP AUTH com swaks"

if [[ "$TLS_MODE" == "wrapper" ]]; then
  swaks --to "$TEST_TO" --from "$MAIL_FROM" --server "$SMTP_HOST" --port "$SMTP_PORT" \
    --helo "$HELO" --tls-on-connect --tls-protocol TLSv1_2 \
    --auth LOGIN --auth-user "$SMTP_USER" --auth-password "$SMTP_PASS"
else
  swaks --to "$TEST_TO" --from "$MAIL_FROM" --server "$SMTP_HOST" --port "$SMTP_PORT" \
    --helo "$HELO" --tls --tls-protocol TLSv1_2 \
    --auth LOGIN --auth-user "$SMTP_USER" --auth-password "$SMTP_PASS"
fi
