#!/usr/bin/env bash
# instalar-postfix-relay.sh
# Configura Postfix como relay SMTP local.
# Fluxo: Aplicação -> 127.0.0.1:25 -> Postfix -> SMTP externo com STARTTLS/TLS + SMTP AUTH

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
CLEAR_QUEUE="${CLEAR_QUEUE:-no}"
BACKUP_DIR="${BACKUP_DIR:-/root/postfix-relay-backup-$(date +%F-%H%M%S)}"

log(){ echo -e "\n[INFO] $*"; }
warn(){ echo -e "\n[WARN] $*" >&2; }
fail(){ echo -e "\n[ERRO] $*" >&2; exit 1; }

require_root(){
  [[ "${EUID}" -eq 0 ]] || fail "Execute como root ou sudo."
}

ask(){
  local var="$1" label="$2" default="$3" secret="${4:-no}" value=""
  if [[ "$secret" == "yes" ]]; then
    read -r -s -p "$label [oculto]: " value
    echo
  else
    read -r -p "$label [$default]: " value
  fi
  [[ -z "$value" ]] && value="$default"
  printf -v "$var" "%s" "$value"
}

interactive(){
  echo "Modo interativo. ENTER aceita o valor padrão."
  ask SMTP_HOST "Servidor SMTP externo" "$SMTP_HOST"
  ask SMTP_PORT "Porta SMTP externa" "$SMTP_PORT"
  ask TLS_MODE "Modo TLS: starttls ou wrapper" "$TLS_MODE"
  ask TLS_PROTOCOL "Protocolo TLS" "$TLS_PROTOCOL"
  ask SMTP_USER "Usuário SMTP" "$SMTP_USER"
  ask SMTP_PASS "Senha SMTP" "$SMTP_PASS" yes
  ask MAIL_FROM "Remetente autorizado/From" "$MAIL_FROM"
  ask TEST_TO "Destinatário para teste" "$TEST_TO"
  ask RUN_SEND_TEST "Executar teste de envio? yes/no" "$RUN_SEND_TEST"
  ask CLEAR_QUEUE "Limpar fila antiga? yes/no" "$CLEAR_QUEUE"
}

confirm(){
  cat <<EOF

============================================================
CONFIGURAÇÃO QUE SERÁ APLICADA
============================================================
SMTP_HOST       = $SMTP_HOST
SMTP_PORT       = $SMTP_PORT
SMTP_USER       = $SMTP_USER
SMTP_PASS       = ********
MAIL_FROM       = $MAIL_FROM
TEST_TO         = $TEST_TO
TLS_MODE        = $TLS_MODE
TLS_PROTOCOL    = $TLS_PROTOCOL
INET_INTERFACES = $INET_INTERFACES
RUN_SEND_TEST   = $RUN_SEND_TEST
CLEAR_QUEUE     = $CLEAR_QUEUE
BACKUP_DIR      = $BACKUP_DIR
============================================================

EOF
  read -r -p "Confirmar? [s/N]: " ok
  [[ "$ok" =~ ^[sS]$ ]] || fail "Cancelado."
}

install_pkgs(){
  log "Instalando pacotes..."
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y postfix s-nail cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nmap-ncat openssl python3 || \
    dnf install -y postfix mailx cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nc openssl python3
  elif command -v yum >/dev/null 2>&1; then
    yum install -y postfix s-nail cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nmap-ncat openssl python3 || \
    yum install -y postfix mailx cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain swaks nc openssl python3
  else
    fail "dnf/yum não encontrado."
  fi
}

backup(){
  log "Criando backup em $BACKUP_DIR..."
  mkdir -p "$BACKUP_DIR"
  [[ -f /etc/postfix/main.cf ]] && cp -p /etc/postfix/main.cf "$BACKUP_DIR/main.cf.bkp"
  [[ -f /etc/postfix/master.cf ]] && cp -p /etc/postfix/master.cf "$BACKUP_DIR/master.cf.bkp"
  [[ -f /etc/postfix/sasl_passwd ]] && cp -p /etc/postfix/sasl_passwd "$BACKUP_DIR/sasl_passwd.bkp"
  [[ -f /etc/postfix/sasl_passwd.db ]] && cp -p /etc/postfix/sasl_passwd.db "$BACKUP_DIR/sasl_passwd.db.bkp"
  [[ -f /etc/group ]] && cp -p /etc/group "$BACKUP_DIR/group.bkp"
}

aliases(){
  log "Criando aliases..."
  touch /etc/aliases
  newaliases || warn "newaliases retornou erro."
}

fix_perms(){
  log "Ajustando permissões conhecidas do Postfix..."
  chgrp postdrop /var/spool/postfix/maildrop 2>/dev/null || true
  chgrp postdrop /var/spool/postfix/public 2>/dev/null || true
  chgrp postdrop /usr/sbin/postdrop 2>/dev/null || true
  chgrp postdrop /usr/sbin/postqueue 2>/dev/null || true

  chmod 730 /var/spool/postfix/maildrop 2>/dev/null || true
  chmod 710 /var/spool/postfix/public 2>/dev/null || true
  chmod 2755 /usr/sbin/postdrop 2>/dev/null || true
  chmod 2755 /usr/sbin/postqueue 2>/dev/null || true
}

configure_postfix(){
  log "Configurando Postfix..."
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

  if [[ "$TLS_MODE" == "wrapper" ]]; then
    postconf -e "smtp_tls_wrappermode = yes"
  else
    postconf -e "smtp_tls_wrappermode = no"
  fi

  postconf -e "inet_interfaces = $INET_INTERFACES"
  postconf -e "mydestination ="
}

sasl(){
  log "Configurando SASL..."
  [[ -n "$SMTP_PASS" ]] || fail "SMTP_PASS vazio."

  cat > /etc/postfix/sasl_passwd <<EOF
[$SMTP_HOST]:$SMTP_PORT $SMTP_USER:$SMTP_PASS
EOF

  postmap /etc/postfix/sasl_passwd
  chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
}

restart(){
  log "Reiniciando Postfix..."
  systemctl enable postfix
  systemctl restart postfix

  if [[ "$CLEAR_QUEUE" == "yes" ]]; then
    postsuper -d ALL
  fi
}

validate(){
  log "Validação da configuração:"
  postconf -n | grep -E 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination' || true

  log "Validação da credencial:"
  local c
  c="$(postmap -q "[$SMTP_HOST]:$SMTP_PORT" hash:/etc/postfix/sasl_passwd || true)"
  [[ -n "$c" ]] || fail "postmap não retornou credencial."
  echo "${c%%:*}:********"

  log "Validação de rede:"
  getent hosts "$SMTP_HOST" || warn "DNS falhou."
  nc -vz -w 5 "$SMTP_HOST" "$SMTP_PORT" || warn "nc falhou."
}

test_local(){
  log "Teste local via Postfix..."
  local cmd
  if command -v s-nail >/dev/null 2>&1; then
    cmd=s-nail
  elif command -v mailx >/dev/null 2>&1; then
    cmd="mailx"
  else
    warn "s-nail/mailx não encontrado."
    return 0
  fi

  echo "Teste via Postfix local em $(hostname) - $(date)" | "$cmd" -r "$MAIL_FROM" -s "Teste Postfix Relay - $(hostname)" "$TEST_TO" || warn "Falha no teste local."
  journalctl -u postfix -n 40 --no-pager || true
}

finish(){
  cat <<EOF

============================================================
FINALIZADO
============================================================

Configuração recomendada na aplicação:

SMTP Host: 127.0.0.1
SMTP Port: 25
SSL: desabilitado
STARTTLS: desabilitado
Autenticação SMTP: desabilitada
From/remetente: $MAIL_FROM

Fluxo:
Aplicação -> 127.0.0.1:25 -> Postfix -> $SMTP_HOST:$SMTP_PORT

Logs:
journalctl -fu postfix

Backup:
$BACKUP_DIR

============================================================
EOF
}

main(){
  require_root
  read -r -p "Deseja preencher de forma interativa? [S/n]: " i
  [[ ! "$i" =~ ^[nN]$ ]] && interactive
  confirm
  backup
  install_pkgs
  aliases
  fix_perms
  configure_postfix
  sasl
  restart
  fix_perms
  restart
  validate
  if [[ "$RUN_SEND_TEST" == "yes" ]]; then
    test_local || warn "teste local falhou."
  fi
  finish
}

main "$@"
