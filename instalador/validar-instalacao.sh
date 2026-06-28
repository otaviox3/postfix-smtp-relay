#!/usr/bin/env bash
set -euo pipefail
systemctl status postfix -l --no-pager || true
postconf -n | egrep 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true
postqueue -p || true
journalctl -u postfix -n 40 --no-pager || true
