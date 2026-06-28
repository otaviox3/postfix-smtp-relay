#!/usr/bin/env bash
set -euo pipefail
MAIL_FROM="${MAIL_FROM:-naoresponda@exemplo.com}"
TEST_TO="${TEST_TO:-destino@exemplo.com}"
echo "Postfix local relay test - $(hostname) - $(date)" | s-nail -r "$MAIL_FROM" -s "Postfix Relay Test - $(hostname)" "$TEST_TO"
journalctl -u postfix -n 40 --no-pager
