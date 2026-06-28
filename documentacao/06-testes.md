# Testes

## Objetivo

Este capítulo descreve os scripts disponíveis para validar a solução.

A partir da versão v1.2.0, o projeto possui testes separados por finalidade e um script geral para executar a validação completa.

## Teste de DNS

```bash
SMTP_HOST="smtp.exemplo.com" ./testes/testar-dns.sh
```

Valida se o host SMTP externo resolve corretamente.

## Teste de conectividade

```bash
SMTP_HOST="smtp.exemplo.com" SMTP_PORT="25" ./testes/testar-conectividade.sh
```

Valida se a porta TCP está acessível.

## Teste TLS

```bash
SMTP_HOST="smtp.exemplo.com" SMTP_PORT="25" TLS_MODE="starttls" ./testes/testar-openssl.sh
```

Valida a negociação TLS com `openssl`.

## Teste SMTP AUTH

```bash
SMTP_HOST="smtp.exemplo.com" \
SMTP_PORT="25" \
SMTP_USER="naoresponda@exemplo.com" \
SMTP_PASS="SENHA_AQUI" \
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-swaks.sh
```

Valida autenticação e envio direto usando Swaks.

## Teste da fila

```bash
./testes/testar-fila.sh
```

Mostra fila do Postfix e últimos logs.

## Teste local via Postfix

```bash
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-postfix.sh
```

Valida envio pela interface local do Postfix.

## Validação completa

```bash
SMTP_HOST="smtp.exemplo.com" \
SMTP_PORT="25" \
TLS_MODE="starttls" \
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-tudo.sh
```

Esse script executa os testes principais em sequência.
