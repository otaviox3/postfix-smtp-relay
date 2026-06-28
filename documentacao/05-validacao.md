# Validação

## Validar serviço

```bash
systemctl status postfix -l --no-pager
```

Esperado:

```text
Active: active (running)
```

## Validar configuração ativa

```bash
postconf -n | egrep 'relayhost|smtp_tls|smtp_sasl|inet_interfaces|mydestination'
```

## Validar credencial SASL

```bash
postmap -q "[smtp.exemplo.com]:25" hash:/etc/postfix/sasl_passwd
```

Esperado:

```text
naoresponda@exemplo.com:SENHA_AQUI
```

## Validar rede

```bash
nc -vz -w 5 smtp.exemplo.com 25
```

Esperado:

```text
succeeded
```

## Validar TLS

```bash
openssl s_client -starttls smtp -connect smtp.exemplo.com:25 -tls1_2 -servername smtp.exemplo.com
```

Esperado:

```text
Verify return code: 0 (ok)
```

## Validar logs

```bash
journalctl -fu postfix
```

Durante envio bem-sucedido:

```text
Trusted TLS connection established
status=sent
250 Message accepted
```
