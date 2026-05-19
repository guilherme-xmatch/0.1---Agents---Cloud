---
description: Audit the current session and repository customization catalog to identify what is missing for a specialist skill focused on creating GitHub Copilot agents in VS Code.
model: Auto
tools: ['search/codebase', 'search/usages', 'runSubagent', 'agent']
---

# Prompt 1: auditar a sessao para skill especialista em criacao de agents

Voce esta continuando a sessao atual. Nao trate este trabalho como uma conversa isolada. Use o contexto ja construido nesta sessao e o estado atual do repositorio como fonte primaria.

## Objetivo

Fazer uma auditoria profunda da sessao aberta e do catalogo local de customizacoes para responder uma pergunta:

"O que ainda falta para eu ter uma skill realmente especialista em criacao de agents locais do GitHub Copilot no VS Code?"

## Escopo obrigatorio

Analise pelo menos:

- `.github/skills/`
- `.github/agents/`
- `.github/prompts/`
- `.github/instructions/`, se existir
- `.github/copilot-instructions.md`, se existir
- `docs/13-github-copilot-vscode-local/`
- `.vscode/mcp.json`, se for relevante ao desenho da skill

## Como trabalhar

1. Use a sessao atual como continuidade. Aproveite o que ja foi pesquisado e materializado.
2. Leia o catalogo atual e identifique overlap, lacunas, naming ruim, fronteiras confusas e assets que ja ajudam na criacao de agents.
3. Descubra quais agents atuais ja cobrem partes do problema:
   - auditoria
   - evidencias
   - benchmark de comunidade
   - arquitetura
   - orquestracao
   - engenharia de customizacoes
4. Identifique o que uma nova skill especialista em criacao de agents precisaria dominar e ainda nao domina bem.
5. Nao edite arquivos nesta etapa. Esta etapa e so diagnostico.

## Delegacao recomendada

Se ajudar, use os agentes ja existentes do repo para dividir a analise:

- `copilot-vscode-auditor-setup.agent.md`
- `copilot-vscode-arquiteto-configuracoes.agent.md`
- `copilot-vscode-orquestrador-subagents.agent.md`

## Perguntas que voce precisa fechar

1. O catalogo atual ja tem uma skill que cria agents de ponta a ponta ou so partes dispersas disso?
2. O repositorio esta mais forte em teoria, em auditoria, em pesquisa ou em materializacao?
3. O que falta para uma skill virar especialista em criacao de agents e nao apenas em customizacoes genericas?
4. Quais artefatos de apoio seriam necessarios para essa skill ficar madura:
   - references/
   - checklists/
   - templates/
   - patterns/

## Formato obrigatorio de saida

Responda em 5 blocos curtos:

1. estado atual da sessao e do catalogo
2. ativos reaproveitaveis para a nova skill
3. lacunas reais
4. riscos de desenho
5. recomendacao de escopo para a skill especialista em criacao de agents

## Regra final

Termine com uma especificacao enxuta e objetiva do que a skill alvo deve conter. Essa especificacao sera a entrada do Prompt 2.