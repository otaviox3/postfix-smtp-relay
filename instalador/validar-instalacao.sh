#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Validando Postfix..."
systemctl status postfix -l --no-pager || true

echo
echo "[INFO] Configuração ativa:"
postconf -n | grep -E 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true

echo
echo "[INFO] Fila:"
postqueue -p || true

echo
echo "[INFO] Últimos logs:"
journalctl -u postfix -n 40 --no-pager || true
