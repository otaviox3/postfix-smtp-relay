#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Validando fila do Postfix"

if ! command -v postqueue >/dev/null 2>&1; then
  echo "[ERRO] postqueue não encontrado. O Postfix está instalado?"
  exit 1
fi

postqueue -p || true

echo
echo "[INFO] Últimos logs do Postfix:"
journalctl -u postfix -n 30 --no-pager || true
