#!/usr/bin/env bash
set -euo pipefail
SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"
TLS_MODE="${TLS_MODE:-starttls}"
if [[ "$TLS_MODE" == "wrapper" ]]; then
  openssl s_client -connect "$SMTP_HOST:$SMTP_PORT" -tls1_2 -servername "$SMTP_HOST"
else
  openssl s_client -starttls smtp -connect "$SMTP_HOST:$SMTP_PORT" -tls1_2 -servername "$SMTP_HOST"
fi
