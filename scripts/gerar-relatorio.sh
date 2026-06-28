#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-relatorio-postfix-relay-$(date +%F-%H%M%S).txt}"

{
  echo "Relatório Postfix SMTP Relay"
  echo "Gerado em: $(date)"
  echo

  echo "== Sistema =="
  uname -a
  echo

  echo "== Host =="
  if command -v hostnamectl >/dev/null 2>&1; then
    hostnamectl 2>/dev/null || hostname
  else
    hostname
  fi
  echo

  echo "== Postfix =="
  if command -v systemctl >/dev/null 2>&1; then
    systemctl status postfix -l --no-pager 2>/dev/null || \
      echo "Postfix não instalado ou serviço indisponível."
  else
    echo "systemctl não disponível."
  fi
  echo

  echo "== Configuração =="
  if command -v postconf >/dev/null 2>&1; then
    postconf -n | grep -E \
      'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true
  else
    echo "postconf não encontrado."
  fi
  echo

  echo "== Fila =="
  if command -v postqueue >/dev/null 2>&1; then
    postqueue -p || true
  else
    echo "postqueue não encontrado."
  fi
  echo

  echo "== Logs =="
  if command -v journalctl >/dev/null 2>&1; then
    journalctl -u postfix -n 80 --no-pager 2>/dev/null || \
      echo "Sem logs do Postfix disponíveis."
  else
    echo "journalctl não disponível."
  fi
  echo

  echo "== Binários encontrados =="
  for cmd in postfix postconf postqueue swaks openssl nc mailx; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf "%-15s : %s\n" "$cmd" "$(command -v "$cmd")"
    else
      printf "%-15s : NÃO INSTALADO\n" "$cmd"
    fi
  done
  echo

} > "$OUT"

echo "[OK] Relatório gerado em: $OUT"
