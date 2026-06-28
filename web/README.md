# Interface Web Local

Interface web simples para validar a solução Postfix SMTP Relay.

## Instalação

```bash
cd web
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Execução

```bash
python app.py
```

Acesse:

```text
http://127.0.0.1:8080
```

> Esta interface deve ser usada localmente ou via túnel SSH. Não exponha diretamente na internet.
