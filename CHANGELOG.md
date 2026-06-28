# Changelog

## v1.3.1 - Correção de CI, ShellCheck e README

### Corrigido

- Remoção de arquivo Python compilado `__pycache__`.
- Inclusão de `__pycache__/` e `*.pyc` no `.gitignore`.
- Correção do aviso ShellCheck `SC2015`.
- Correção do aviso ShellCheck `SC2209`.
- Restauração do README mais completo, mantendo as melhorias da interface web, relatório técnico e CI.

## v1.3.0 - Interface web local e CI corrigido

### Adicionado

- Interface web local com Flask.
- Página de validação por navegador.
- Página de logs do Postfix.
- Script de geração de relatório.
- Documentação da interface web.
- CI validando aplicação Python.

## v1.2.0 - Melhorias de README, testes e CI

### Adicionado

- README mais completo.
- Teste de DNS.
- Teste de fila do Postfix.
- Script `testar-tudo.sh`.
- CI com validação de sintaxe Bash.
- ShellCheck.
- Verificação básica contra dados sensíveis.
