# Segurança

## Não versionar dados sensíveis

Nunca envie para o GitHub:

- senhas SMTP;
- tokens;
- chaves privadas;
- IPs internos;
- domínios internos;
- hostnames reais;
- nomes de aplicações internas;
- arquivos `.env`;
- arquivos `sasl_passwd`;
- arquivos `sasl_passwd.db`.

## Permissões

O arquivo de credenciais deve ter permissão restrita:

```bash
chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

## Escuta local

Recomendado:

```text
inet_interfaces = loopback-only
```

Isso evita expor o Postfix como relay aberto na rede.

## Placeholders

Use exemplos genéricos:

```text
smtp.exemplo.com
naoresponda@exemplo.com
SENHA_AQUI
```

## Rotação de senha

Após testes ou compartilhamento temporário de credenciais, rotacione a senha SMTP.
