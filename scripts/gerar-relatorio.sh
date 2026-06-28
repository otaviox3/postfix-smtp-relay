#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-relatorio-postfix-relay-$(date +%F-%H%M%S).txt}"

{
  echo "Relatório Postfix SMTP Relay"
  echo "Gerado em: $(date)"
  echo
  echo "== Host =="
  hostnamectl 2>/dev/null || hostname
  echo
  echo "== Postfix =="
  systemctl status postfix -l --no-pager || true
  echo
  echo "== Configuração =="
  postconf -n | grep -E 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true
  echo
  echo "== Fila =="
  postqueue -p || true
  echo
  echo "== Logs =="
  journalctl -u postfix -n 80 --no-pager || true
} > "$OUT"

echo "[OK] Relatório gerado em: $OUT"
