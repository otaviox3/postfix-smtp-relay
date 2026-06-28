# Contribuindo

Contribuições são bem-vindas.

## Padrão do projeto

- Toda documentação deve estar em português.
- Scripts devem ser escritos em Bash.
- Exemplos devem usar dados fictícios.
- Não envie credenciais reais.
- Não envie domínios internos, IPs internos ou nomes de aplicações reais.

## Validação local

Antes de enviar mudanças:

```bash
bash -n instalador/*.sh
bash -n testes/*.sh
```

Também execute:

```bash
grep -RniE "EXEMPLO_SENHA|naoresponda-exemplo|empresa-exemplo|dominio-exemplo|sistema-exemplo|10\.100|senha real" . --exclude-dir=.git
```

## ShellCheck

Quando disponível:

```bash
shellcheck instalador/*.sh
shellcheck testes/*.sh
```

## Commits

Sugestão de padrão:

```text
feat: adiciona nova funcionalidade
fix: corrige problema
docs: atualiza documentação
test: adiciona ou melhora testes
ci: ajusta GitHub Actions
```
