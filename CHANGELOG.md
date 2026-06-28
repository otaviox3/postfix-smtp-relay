# Changelog

Todas as mudanças relevantes deste projeto serão documentadas neste arquivo.

## v1.0.9 - Testes automáticos funcionais

* Scripts de relatório tornados compatíveis com ambientes sem Postfix instalado.
* Adicionado workflow `tests.yml`.
* Scripts de relatório agora funcionam mesmo sem Postfix instalado.
* Melhor tratamento de erros e compatibilidade com GitHub Actions.

## v1.0.8 - Integração com CodeQL

* Adicionada análise estática de segurança usando GitHub CodeQL.
* Novo workflow `.github/workflows/codeql.yml`.
* Execução automática em push, pull request e semanalmente.
* Preparação do projeto para futuras melhorias de segurança.

## v1.0.7 - Correção do workflow de release

* Corrigida a identação do workflow `release.yml`.
* Adicionado suporte à geração automática das notas de release a partir do `CHANGELOG.md`.
* Corrigido o pipeline de criação de Releases no GitHub Actions.
* Mantida a geração automática dos artefatos `.zip` e `.tar.gz`.

## v1.0.6 - Release automática aprimorada

### Adicionado

* Workflow de Release automático via GitHub Actions.
* Geração automática de arquivos `.zip` e `.tar.gz`.
* Descrição da Release baseada no `CHANGELOG.md`.
* Fallback automático caso a versão não exista no changelog.

### Melhorado

* Processo de publicação de novas versões.
* Padronização das notas de release.
* Automação do ciclo de distribuição do projeto.

## v1.0.3 - Atualização de documentação

* Removidas referências às versões antigas do projeto.
* README atualizado para refletir o estado atual do repositório.
* Ajustes de organização da documentação.

## v1.0.2 - Screenshot da interface web

* Adicionada imagem da interface web local no README.
* Melhorias de apresentação da documentação.

## v1.0.1 - Correções de CI

* Ajustes no GitHub Actions.
* Correções apontadas pelo ShellCheck.
* Limpeza do repositório e remoção de referências específicas.

## v1.0.0 - Versão inicial pública

* Instalador automatizado do Postfix Relay SMTP.
* Scripts de validação e troubleshooting.
* Interface web local para validação operacional.
* Geração de relatórios.
* Documentação completa.
* Integração com GitHub Actions.
