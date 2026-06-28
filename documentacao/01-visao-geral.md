# Visão Geral

## Objetivo

Este projeto documenta e automatiza a configuração do **Postfix como relay SMTP local** para aplicações legadas.

A solução permite que aplicações antigas continuem enviando e-mails por servidores SMTP modernos, mesmo quando a aplicação não consegue negociar corretamente autenticação, STARTTLS ou TLS.

## Problema

Aplicações legadas podem apresentar falhas quando o servidor SMTP exige:

- autenticação SMTP;
- STARTTLS;
- TLS 1.2 ou superior;
- remetente autorizado;
- políticas modernas de segurança.

Erros comuns:

```text
535 Authentication Failed
554 Relaying Denied
SSLHandshakeException
Connection timed out
```

## Solução

A aplicação envia e-mails localmente para o Postfix:

```text
127.0.0.1:25
```

O Postfix fica responsável por:

- autenticar no SMTP externo;
- negociar STARTTLS/TLS;
- enfileirar mensagens;
- realizar retry automático;
- registrar logs;
- encaminhar mensagens ao servidor SMTP externo.

## Fluxo geral

```mermaid
flowchart LR
    A[Aplicação legada] -->|SMTP local| B[Postfix local]
    B -->|SMTP AUTH + STARTTLS/TLS| C[SMTP externo]
    C --> D[Destinatários]
```

## Resultado esperado

A aplicação fica mais simples e o Postfix assume a complexidade do envio externo.
