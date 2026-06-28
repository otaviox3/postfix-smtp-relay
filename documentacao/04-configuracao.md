# Configuração

## Arquivo principal

A configuração principal do Postfix fica em:

```text
/etc/postfix/main.cf
```

## Parâmetros principais

### relayhost

```text
relayhost = [smtp.exemplo.com]:25
```

Define o servidor SMTP externo para onde o Postfix encaminhará as mensagens.

### smtp_sasl_auth_enable

```text
smtp_sasl_auth_enable = yes
```

Habilita autenticação SMTP.

### smtp_sasl_password_maps

```text
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
```

Define o arquivo com usuário e senha do SMTP externo.

### smtp_tls_security_level

```text
smtp_tls_security_level = encrypt
```

Exige criptografia TLS na comunicação com o SMTP externo.

### smtp_tls_wrappermode

```text
smtp_tls_wrappermode = no
```

Use `no` para portas 25/587 com STARTTLS.

Use `yes` para porta 465 com SMTPS direto.

### inet_interfaces

```text
inet_interfaces = loopback-only
```

Faz o Postfix escutar somente localmente.

## Arquivo de senha

Criar:

```text
/etc/postfix/sasl_passwd
```

Exemplo:

```text
[smtp.exemplo.com]:25 naoresponda@exemplo.com:SENHA_AQUI
```

Gerar mapa:

```bash
postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

## Configuração na aplicação

```text
Host SMTP: 127.0.0.1
Porta SMTP: 25
SSL: desabilitado
STARTTLS: desabilitado
Autenticação: desabilitada
```
