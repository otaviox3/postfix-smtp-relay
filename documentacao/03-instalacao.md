# Instalação

## Pré-requisitos

Distribuições recomendadas:

- Oracle Linux 8/9
- RHEL 8/9
- Rocky Linux 8/9
- AlmaLinux 8/9

Pacotes utilizados:

- postfix
- cyrus-sasl
- cyrus-sasl-plain
- openssl
- swaks
- s-nail ou mailx
- nmap-ncat

## Instalação interativa

```bash
chmod +x instalador/instalar-postfix-relay.sh
sudo ./instalador/instalar-postfix-relay.sh
```

O instalador solicita:

- servidor SMTP;
- porta;
- modo TLS;
- usuário SMTP;
- senha SMTP;
- remetente;
- destinatário de teste.

## Instalação com variáveis

```bash
sudo SMTP_HOST="smtp.exemplo.com" \
SMTP_PORT="25" \
TLS_MODE="starttls" \
TLS_PROTOCOL="TLSv1.2" \
SMTP_USER="naoresponda@exemplo.com" \
SMTP_PASS="SENHA_AQUI" \
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
RUN_SEND_TEST="yes" \
./instalador/instalar-postfix-relay.sh
```

## Modos TLS

| Porta | TLS_MODE | Descrição |
|---|---|---|
| 25 | starttls | SMTP com STARTTLS |
| 587 | starttls | Submission com STARTTLS |
| 465 | wrapper | SMTPS direto |

## Verificação após instalação

```bash
systemctl status postfix -l --no-pager
postconf -n
journalctl -u postfix -n 50 --no-pager
```
