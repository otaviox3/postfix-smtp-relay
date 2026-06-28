#!/usr/bin/env bash
set -Eeuo pipefail
SMTP_HOST="${SMTP_HOST:-smtp.exemplo.com}"
SMTP_PORT="${SMTP_PORT:-25}"
SMTP_USER="${SMTP_USER:-naoresponda@exemplo.com}"
SMTP_PASS="${SMTP_PASS:-}"
MAIL_FROM="${MAIL_FROM:-naoresponda@exemplo.com}"
TEST_TO="${TEST_TO:-destino@exemplo.com}"
TLS_MODE="${TLS_MODE:-starttls}"
TLS_PROTOCOL="${TLS_PROTOCOL:-TLSv1.2}"
INET_INTERFACES="${INET_INTERFACES:-loopback-only}"
RUN_SEND_TEST="${RUN_SEND_TEST:-yes}"
BACKUP_DIR="${BACKUP_DIR:-/root/postfix-relay-backup-$(date +%F-%H%M%S)}"
log(){ echo -e "\n[INFO] $*"; }
warn(){ echo -e "\n[WARN] $*" >&2; }
fail(){ echo -e "\n[ERRO] $*" >&2; exit 1; }
[[ "${EUID}" -eq 0 ]] || fail "Execute como root ou sudo."
read -r -p "Preencher de forma interativa? [S/n]: " i
if [[ ! "$i" =~ ^[nN]$ ]]; then
  read -r -p "Servidor SMTP [$SMTP_HOST]: " v; SMTP_HOST="${v:-$SMTP_HOST}"
  read -r -p "Porta SMTP [$SMTP_PORT]: " v; SMTP_PORT="${v:-$SMTP_PORT}"
  read -r -p "Modo TLS starttls/wrapper [$TLS_MODE]: " v; TLS_MODE="${v:-$TLS_MODE}"
  read -r -p "Usuário SMTP [$SMTP_USER]: " v; SMTP_USER="${v:-$SMTP_USER}"
  read -r -s -p "Senha SMTP: " v; echo; SMTP_PASS="${v:-$SMTP_PASS}"
  read -r -p "Remetente [$MAIL_FROM]: " v; MAIL_FROM="${v:-$MAIL_FROM}"
  read -r -p "Destinatário de teste [$TEST_TO]: " v; TEST_TO="${v:-$TEST_TO}"
fi
[[ -n "$SMTP_PASS" ]] || fail "Senha SMTP vazia."
mkdir -p "$BACKUP_DIR"
cp -p /etc/postfix/main.cf "$BACKUP_DIR/main.cf.bkp" 2>/dev/null || true
cp -p /etc/postfix/master.cf "$BACKUP_DIR/master.cf.bkp" 2>/dev/null || true
if command -v dnf >/dev/null 2>&1; then
  dnf install -y postfix s-nail cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nmap-ncat openssl
elif command -v yum >/dev/null 2>&1; then
  yum install -y postfix s-nail cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nmap-ncat openssl
else
  fail "dnf/yum não encontrado."
fi
touch /etc/aliases
newaliases || true
postconf -e "relayhost = [$SMTP_HOST]:$SMTP_PORT"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_sasl_tls_security_options = noanonymous"
postconf -e "smtp_sasl_mechanism_filter = plain, login"
postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_tls_protocols = $TLS_PROTOCOL"
postconf -e "smtp_tls_mandatory_protocols = $TLS_PROTOCOL"
postconf -e "smtp_tls_loglevel = 1"
[[ "$TLS_MODE" == "wrapper" ]] && postconf -e "smtp_tls_wrappermode = yes" || postconf -e "smtp_tls_wrappermode = no"
postconf -e "inet_interfaces = $INET_INTERFACES"
postconf -e "mydestination ="
cat > /etc/postfix/sasl_passwd <<EOF
[$SMTP_HOST]:$SMTP_PORT $SMTP_USER:$SMTP_PASS
EOF
postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
systemctl enable postfix
systemctl restart postfix
postconf -n | egrep 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true
postmap -q "[$SMTP_HOST]:$SMTP_PORT" hash:/etc/postfix/sasl_passwd | sed 's/:.*/:********/' || true
nc -vz -w 5 "$SMTP_HOST" "$SMTP_PORT" || warn "Teste de rede falhou."
if [[ "$RUN_SEND_TEST" == "yes" ]]; then
  echo "Teste via Postfix local em $(hostname) - $(date)" | s-nail -r "$MAIL_FROM" -s "Teste Postfix Relay - $(hostname)" "$TEST_TO" || warn "Teste de envio falhou."
  journalctl -u postfix -n 40 --no-pager || true
fi
echo "Instalação finalizada. Backup: $BACKUP_DIR"
