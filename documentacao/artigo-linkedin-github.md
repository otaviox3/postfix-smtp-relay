# Divulgação profissional

## Vale a pena postar no LinkedIn?

Sim. Vale a pena, desde que você remova nomes da empresa, aplicação real, domínios, IPs, usuários, e qualquer dado sensível.

A melhor forma é apresentar como caso técnico genérico.

## Post sugerido para LinkedIn

Recentemente implementei uma solução para compatibilizar uma aplicação legada com um servidor SMTP moderno que exige autenticação e TLS 1.2.

O ambiente possuía uma aplicação antiga que apresentava falhas ao negociar TLS diretamente com o SMTP externo. Para resolver, desenhei e implementei um relay SMTP local com Postfix.

O fluxo final ficou assim:

```text
Aplicação legada
  -> Postfix local em 127.0.0.1:25
  -> SMTP externo com STARTTLS/TLS 1.2 e SMTP AUTH
  -> Destinatários externos
```

Com essa abordagem, a aplicação deixou de negociar TLS diretamente. O Postfix passou a assumir autenticação, criptografia, logs, filas e retentativas.

Também criei um script de automação para instalação e configuração, incluindo:

- instalação dos pacotes;
- configuração do Postfix;
- autenticação SASL;
- STARTTLS/TLS 1.2;
- testes com `nc`, `openssl`, `swaks` e `s-nail`;
- troubleshooting para erros como `535 authentication failed`, `554 Relaying denied`, timeout e inconsistências de permissão;
- documentação para replicação em múltiplos servidores.

Tecnologias envolvidas:

```text
Linux
Postfix
SMTP
SASL
STARTTLS
TLS 1.2
swaks
openssl
shell script
aplicações legadas
```

Esse tipo de solução mostra como uma intervenção de infraestrutura bem planejada pode resolver limitações de aplicações legadas sem exigir alteração profunda no código.

## Sugestão para GitHub

Nome do repositório:

```text
postfix-local-relay-smtp
```

Descrição:

```text
Script para configurar Postfix como relay SMTP local para aplicações legadas que precisam enviar e-mails por SMTP autenticado com STARTTLS/TLS.
```

Estrutura:

```text
postfix-local-relay-smtp/
├── README.md
├── install-postfix-relay.sh
├── linkedin-github.md
└── .gitignore
```

## Frase para currículo

Implementei uma solução de relay SMTP local com Postfix para compatibilizar aplicações legadas com servidores SMTP modernos utilizando STARTTLS/TLS 1.2 e autenticação SASL, incluindo automação de instalação, troubleshooting e documentação operacional.
