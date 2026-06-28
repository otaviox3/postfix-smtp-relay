#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "Validação completa - Postfix SMTP Relay"
echo "============================================================"

echo
echo "[1/5] DNS"
"$DIR/testar-dns.sh"

echo
echo "[2/5] Conectividade"
"$DIR/testar-conectividade.sh"

echo
echo "[3/5] TLS"
"$DIR/testar-openssl.sh"

echo
echo "[4/5] Fila Postfix"
"$DIR/testar-fila.sh"

echo
echo "[5/5] Envio local via Postfix"
"$DIR/testar-postfix.sh"

echo
echo "============================================================"
echo "[OK] Validação completa finalizada."
echo "============================================================"
