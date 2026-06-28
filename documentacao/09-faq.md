# FAQ

## A aplicação precisa autenticar?

Não. A aplicação envia para o Postfix local sem autenticação.

Quem autentica no servidor SMTP externo é o Postfix.

## A aplicação precisa usar TLS?

Não. A aplicação envia para `127.0.0.1:25`.

Quem negocia STARTTLS/TLS é o Postfix.

## Posso usar porta 465?

Sim.

```bash
TLS_MODE="wrapper"
SMTP_PORT="465"
```

## Posso usar porta 25 ou 587?

Sim.

```bash
TLS_MODE="starttls"
SMTP_PORT="25"
```

ou:

```bash
TLS_MODE="starttls"
SMTP_PORT="587"
```

## Isso cria relay aberto?

Não, desde que use:

```text
inet_interfaces = loopback-only
```

## Funciona com vários servidores de aplicação?

Sim. A configuração pode ser replicada em cada nó de aplicação.

## Posso centralizar em um relay único?

Sim, mas nesse caso é necessário planejar:

- firewall;
- controle de origem;
- regras anti-open-relay;
- monitoramento;
- alta disponibilidade.
