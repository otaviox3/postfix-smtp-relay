# Interface Web Local

## Objetivo

A interface web permite validar rapidamente a solução pelo navegador.

Ela executa validações locais como:

- DNS;
- conectividade;
- TLS;
- fila do Postfix;
- últimos logs do serviço.

## Execução

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

## Segurança

A interface escuta somente em `127.0.0.1`.

Não exponha essa interface diretamente na internet.
