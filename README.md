# Postfix SMTP Relay

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Linux](https://img.shields.io/badge/Linux-Oracle%20Linux%20%7C%20RHEL%20%7C%20Rocky%20%7C%20Alma-red)
![Postfix](https://img.shields.io/badge/Postfix-SMTP%20Relay-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Licença](https://img.shields.io/badge/licen%C3%A7a-MIT-lightgrey)

## Sobre o projeto

Este projeto fornece uma solução para configurar o **Postfix como relay SMTP local** para aplicações legadas que precisam enviar e-mails por meio de servidores SMTP modernos com autenticação, STARTTLS e TLS.

A ideia principal é simples:

> A aplicação envia e-mails para `127.0.0.1:25`, e o Postfix fica responsável por autenticar, negociar TLS, enfileirar, registrar logs e encaminhar a mensagem para o servidor SMTP externo.

Essa abordagem é útil quando a aplicação utiliza uma stack antiga e não consegue negociar corretamente TLS ou autenticação SMTP com servidores modernos.

---

## Índice

- [Sobre o projeto](#sobre-o-projeto)
- [Problema resolvido](#problema-resolvido)
- [Arquitetura](#arquitetura)
- [Benefícios](#benefícios)
- [Tecnologias utilizadas](#tecnologias-utilizadas)
- [Estrutura do projeto](#estrutura-do-projeto)
- [Instalação rápida](#instalação-rápida)
- [Instalação com variáveis](#instalação-com-variáveis)
- [Configuração esperada na aplicação](#configuração-esperada-na-aplicação)
- [Testes](#testes)
- [Logs](#logs)
- [Resultado esperado](#resultado-esperado)
- [Troubleshooting rápido](#troubleshooting-rápido)
- [Segurança](#segurança)
- [Roadmap](#roadmap)
- [Licença](#licença)
- [Autor](#autor)

---

## Problema resolvido

Aplicações legadas podem apresentar erros ao tentar enviar e-mails diretamente para servidores SMTP que exigem autenticação e TLS moderno.

Erros comuns:

```text
535 Authentication Failed
554 Relaying Denied
SSLHandshakeException
Connection timed out
