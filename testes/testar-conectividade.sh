#!/usr/bin/env bash
set -euo pipefail
SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"
getent hosts "$SMTP_HOST"
nc -vz -w 5 "$SMTP_HOST" "$SMTP_PORT"
