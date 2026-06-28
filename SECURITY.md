# Política de Segurança

Nunca envie para o repositório senhas SMTP, tokens, chaves privadas, IPs internos, domínios internos, nomes reais de aplicações internas, `.env`, `sasl_passwd` ou `sasl_passwd.db`.

Recomendações:

- Use variáveis de ambiente para segredos.
- Use placeholders em exemplos.
- Mantenha `/etc/postfix/sasl_passwd` com permissão `600`.
- Use `inet_interfaces = loopback-only`.
