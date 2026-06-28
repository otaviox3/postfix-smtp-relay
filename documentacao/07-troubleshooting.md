# Troubleshooting

## 535 Authentication Failed

Erro:

```text
535 5.7.0 authentication failed
```

Causas prováveis:

- usuário SMTP incorreto;
- senha incorreta;
- conta sem permissão de SMTP AUTH;
- mecanismo de autenticação incompatível.

Validação:

```bash
swaks --server smtp.exemplo.com --port 25 --tls \
--auth LOGIN \
--auth-user naoresponda@exemplo.com \
--auth-password 'SENHA_AQUI'
```

## 554 Relaying Denied

Erro:

```text
554 5.7.1 Relaying denied
```

Causas prováveis:

- Postfix não autenticou;
- `sasl_passwd` incorreto;
- `postmap` não foi executado;
- porta do `relayhost` diferente da porta no `sasl_passwd`.

Validação:

```bash
postmap -q "[smtp.exemplo.com]:25" hash:/etc/postfix/sasl_passwd
postconf -n | grep smtp_sasl
```

## Connection timed out

Causas prováveis:

- firewall;
- ACL;
- rota;
- servidor SMTP indisponível.

Validação:

```bash
nc -vz -w 5 smtp.exemplo.com 25
```

## Different sender identity is not allowed

Causa provável:

- remetente diferente do usuário autorizado no SMTP externo.

Correção:

```text
MAIL_FROM deve ser o remetente autorizado.
```

## Warning postdrop/postqueue

Validar:

```bash
ls -ld /var/spool/postfix/maildrop /var/spool/postfix/public
ls -l /usr/sbin/postdrop /usr/sbin/postqueue
```
