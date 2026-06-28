# Changelog

## v1.3.0 - Interface web local e CI corrigido

### Adicionado

- Interface web local com Flask.
- Página de validação por navegador.
- Página de logs do Postfix.
- Script de geração de relatório.
- Documentação da interface web.
- CI validando aplicação Python.
- Scripts corrigidos para ShellCheck.

### Corrigido

- Avisos SC2015.
- Avisos SC2196.
- Uso de `grep -E` no lugar de `egrep`.

## v1.2.0 - Melhorias de README, testes e CI

### Adicionado

- README mais completo.
- Teste de DNS.
- Teste de fila do Postfix.
- Script `testar-tudo.sh`.
- CI com validação de sintaxe Bash.
- CI com ShellCheck.
- CI com verificação básica contra dados sensíveis.
