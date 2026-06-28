#!/usr/bin/env bash
set -euo pipefail

SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"
TLS_MODE="${TLS_MODE:-starttls}"

echo "[INFO] Testando TLS em $SMTP_HOST:$SMTP_PORT usando modo $TLS_MODE"

if [[ "$TLS_MODE" == "wrapper" ]]; then
  timeout 15 openssl s_client -connect "$SMTP_HOST:$SMTP_PORT" -tls1_2 -servername "$SMTP_HOST" </dev/null
else
  timeout 15 openssl s_client -starttls smtp -connect "$SMTP_HOST:$SMTP_PORT" -tls1_2 -servername "$SMTP_HOST" </dev/null
fi
