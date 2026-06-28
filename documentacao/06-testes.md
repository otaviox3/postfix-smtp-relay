# Testes

## Teste de DNS e porta

```bash
SMTP_HOST="smtp.exemplo.com" SMTP_PORT="25" ./testes/testar-conectividade.sh
```

Esse teste valida:

- resolução DNS;
- conectividade TCP;
- liberação da porta.

## Teste TLS

```bash
SMTP_HOST="smtp.exemplo.com" SMTP_PORT="25" TLS_MODE="starttls" ./testes/testar-openssl.sh
```

Esse teste valida se o SMTP aceita STARTTLS/TLS.

## Teste SMTP AUTH com Swaks

```bash
SMTP_HOST="smtp.exemplo.com" \
SMTP_PORT="25" \
SMTP_USER="naoresponda@exemplo.com" \
SMTP_PASS="SENHA_AQUI" \
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-swaks.sh
```

Esse teste valida:

- conexão;
- STARTTLS;
- autenticação;
- envio SMTP.

## Teste local via Postfix

```bash
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-postfix.sh
```

Esse teste valida se o Postfix local está encaminhando mensagens corretamente.

## Resultado esperado

```text
status=sent
250 Message accepted
```
