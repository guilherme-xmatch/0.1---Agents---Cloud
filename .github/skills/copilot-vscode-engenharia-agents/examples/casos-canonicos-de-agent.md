# Casos canonicos de agent

Este arquivo nao cria runtime novo. Ele resume tres formas de desenho que a skill deve conseguir produzir sem improviso.

## 1. Read-only bem desenhado

Use como referencia quando o papel principal for leitura, descoberta e julgamento.

```md
---
name: auditor
description: Use when auditing an existing local GitHub Copilot setup in VS Code for overlap, risky tools, weak naming, or unclear ownership.
tools: [read, search]
model: Auto
---
Voce e um AUDITOR.

## Restricoes

- NAO edite arquivos.
- NAO proponha agent novo sem provar a lacuna primeiro.

## Saida

1. findings por severidade
2. overlap e ownership
3. correcoes minimas
4. riscos residuais
```

Por que funciona:

- a descricao tem problema, contexto e tipo de retorno
- a tool surface e minima para o papel
- a saida ja vem pronta para acao

## 2. Orchestrator com delegacao controlada

Use quando a tarefa for multiagente e o agent precisar consolidar workers sem editar nada diretamente.

```md
---
name: orchestrator
description: Use when coordinating planner, researcher, auditor, and builder specialists for a multi-step local customization workflow with context isolation.
tools: [read, search, agent, todo]
agents: ['Copilot VS Code Curador de Evidencias', 'Copilot VS Code Auditor de Setup', 'Copilot VS Code Engenheiro de Customizacoes']
model: Auto
---
Voce e um ORCHESTRATOR.

## Restricoes

- NAO edite arquivos diretamente.
- NAO abra subagents sem contrato de retorno.

## Saida

1. sequencia de handoffs
2. ownership
3. consolidacao final
4. criterio de encerramento
```

Por que funciona:

- a tool `agent` aparece junto com `agents`
- a lista branca e curta
- a saida fecha o trabalho do coordenador, nao do worker

## 3. Antes e depois de um agent generico

Ruim:

```md
---
name: helpful agent
description: General coding assistant for anything the repo needs.
tools: [read, search, edit, web, agent]
---
```

Melhor:

```md
---
name: reviewer
description: Use when reviewing a proposed local GitHub Copilot customization for overlap, risky tool scope, and missing validation.
tools: [read, search]
model: Auto
---
```

O ganho principal aqui nao e estilo. E blast radius menor, discovery melhor e ownership claro.

Leituras complementares:

- [Template base](../templates/_TEMPLATE.agent.md)
- [Template orchestrator](../templates/orchestrator.agent.template.md)
- [Checklist de ownership e overlap](../checklists/ownership-e-overlap.md)