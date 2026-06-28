# Postfix SMTP Relay

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Linux](https://img.shields.io/badge/Linux-Oracle%20Linux%20%7C%20RHEL%20%7C%20Rocky%20%7C%20Alma-red)
![Postfix](https://img.shields.io/badge/Postfix-SMTP%20Relay-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-green)
![CI](https://img.shields.io/badge/GitHub%20Actions-Shell%20Validation-blue)
![Licença](https://img.shields.io/badge/licen%C3%A7a-MIT-lightgrey)

## Sobre o projeto

O **Postfix SMTP Relay** é uma solução em português para configurar o **Postfix como relay SMTP local** para aplicações legadas.

A aplicação envia e-mails para `127.0.0.1:25`, e o Postfix fica responsável por autenticação SMTP, STARTTLS/TLS, fila, logs, retry e encaminhamento para o servidor SMTP externo.

---

## Arquitetura

```mermaid
flowchart LR
    A[Aplicação legada] -->|SMTP local<br>127.0.0.1:25| B[Postfix Relay Local]
    B -->|SMTP AUTH<br>STARTTLS/TLS 1.2| C[Servidor SMTP externo]
    C --> D[Destinatários]
```

---

## Funcionalidades

- [x] Configuração do Postfix como relay SMTP local.
- [x] Suporte a STARTTLS.
- [x] Suporte a TLS 1.2.
- [x] SMTP AUTH via SASL.
- [x] Instalador em Bash.
- [x] Backup antes de alterar configurações.
- [x] Script de rollback.
- [x] Scripts de teste.
- [x] Validação completa em um único comando.
- [x] Interface web local para validação.
- [x] GitHub Actions com ShellCheck e validação de segurança.
- [x] Documentação em português.

---

## Instalação rápida

```bash
git clone git@github.com:otaviox3/postfix-smtp-relay.git
cd postfix-smtp-relay

chmod +x instalador/*.sh testes/*.sh scripts/*.sh
sudo ./instalador/instalar-postfix-relay.sh
```

---

## Validação completa

```bash
SMTP_HOST="smtp.exemplo.com" \
SMTP_PORT="25" \
TLS_MODE="starttls" \
MAIL_FROM="naoresponda@exemplo.com" \
TEST_TO="destino@exemplo.com" \
./testes/testar-tudo.sh
```

---

## Interface web local

```bash
cd web
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Acesse:

```text
http://127.0.0.1:8080
```

> A interface web deve ser usada localmente ou via túnel SSH. Não exponha diretamente na internet.

---

## Documentação

- [Visão geral](documentacao/01-visao-geral.md)
- [Arquitetura](documentacao/02-arquitetura.md)
- [Instalação](documentacao/03-instalacao.md)
- [Configuração](documentacao/04-configuracao.md)
- [Validação](documentacao/05-validacao.md)
- [Testes](documentacao/06-testes.md)
- [Troubleshooting](documentacao/07-troubleshooting.md)
- [Segurança](documentacao/08-seguranca.md)
- [FAQ](documentacao/09-faq.md)
- [Roadmap](documentacao/10-roadmap.md)
- [Interface web](documentacao/11-interface-web.md)

---

## Autor

Desenvolvido por **Otávio Azevedo**.

---

## Licença

Este projeto está licenciado sob a licença MIT.
