# Arquitetura

## Modelo antes da solução

Antes da implantação do relay local, a aplicação se conectava diretamente ao SMTP externo.

```mermaid
flowchart LR
    A[Aplicação legada] -->|SMTP direto| B[Servidor SMTP externo]
    B --> C[Destinatários]
```

Nesse modelo, a aplicação precisa lidar com:

- autenticação;
- TLS;
- certificados;
- compatibilidade de protocolo;
- erros de entrega.

## Modelo depois da solução

Com o Postfix local, a aplicação envia para `127.0.0.1:25`.

```mermaid
flowchart LR
    A[Aplicação legada] -->|127.0.0.1:25| B[Postfix Relay Local]
    B -->|SMTP AUTH| C[STARTTLS/TLS 1.2]
    C --> D[Servidor SMTP externo]
    D --> E[Destinatários]
```

## Sequência técnica

```mermaid
sequenceDiagram
    participant APP as Aplicação
    participant PF as Postfix Local
    participant SMTP as SMTP Externo
    participant DST as Destinatário

    APP->>PF: Envia mensagem via localhost:25
    PF->>PF: Coloca mensagem na fila
    PF->>SMTP: Conecta no SMTP externo
    PF->>SMTP: Inicia STARTTLS
    SMTP-->>PF: TLS estabelecido
    PF->>SMTP: Autentica via SASL
    SMTP-->>PF: Autenticação aceita
    PF->>SMTP: Envia mensagem
    SMTP-->>PF: 250 Message accepted
    SMTP->>DST: Entrega ao destinatário
```

## Responsabilidades

| Componente | Responsabilidade |
|---|---|
| Aplicação | Enviar e-mail para `127.0.0.1:25` |
| Postfix | TLS, autenticação, fila, logs e encaminhamento |
| SMTP externo | Receber e entregar mensagens autenticadas |
| Destinatário | Receber a mensagem |
