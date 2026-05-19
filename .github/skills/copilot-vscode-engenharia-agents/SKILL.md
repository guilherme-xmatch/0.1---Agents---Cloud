---
name: copilot-vscode-engenharia-agents
description: Cria, revisa e endurece custom agents `.agent.md` para GitHub Copilot local no VS Code. Use quando precisar desenhar papeis, gatilhos de descoberta, frontmatter, tools minimas, modelos, handoffs, subagents, hooks inline e contratos de saida de agents especialistas.
---

# Copilot VS Code: engenharia de agents

Use esta skill quando:

- o objetivo principal for criar ou evoluir `.github/agents/*.agent.md`
- o desafio estiver em definir papel, descricao, trigger phrases, tools, model, handoffs ou subagents
- um agent atual estiver amplo demais, vago demais ou perigoso demais
- o time quiser transformar conhecimento especializado em um agent invocavel e sustentavel

Nao use esta skill quando:

- a tarefa principal for editar instructions, prompts, hooks, skills ou MCP sem que o agent seja o problema central
- o pedido for apenas escolher a superficie correta entre varias customizacoes, sem necessidade de materializar `.agent.md`
- a necessidade for so rollout, governance geral ou benchmarking sem design de agent

## Missao

Projetar agents extremamente especialistas, com uma unica responsabilidade central, descricao forte para descoberta, tool surface minima, fronteiras claras e contrato de saida que permita delegacao segura.

## Principios obrigatorios

- um papel por agent
- descricao e a superficie de descoberta: ela precisa conter os gatilhos reais de uso
- tools minimas antes de qualquer ganho de conveniencia
- se o agent usa `agents`, ele precisa da tool `agent`
- read-only por default para planner, researcher, auditor, benchmarker e arquiteto
- `edit` so para agents cujo trabalho principal e materializar artefatos
- `execute`, `web` e MCP so entram com justificativa explicita
- nao introduza `.chatmode.md` novo

## Fluxo de trabalho

1. Defina a missao do agent em uma frase verificavel.
2. Escolha a classe do agent:
   - planner
   - researcher
   - executor
   - reviewer
   - auditor
   - orchestrator
   - operator
3. Escreva a descricao com palavras que permitam descoberta por delegacao.
4. Defina o menor conjunto de tools e o modelo adequado.
5. Decida se o agent e user-invocable ou so subagent.
6. Se houver subagents permitidos, restrinja explicitamente o campo `agents`.
7. Escreva corpo com restricoes, abordagem e formato de saida.
8. Valide frontmatter, naming, links e blast radius.

## Entradas minimas antes de criar um agent

1. problema exato que o agent resolve
2. o que ele nunca deve fazer
3. que artefato ou output precisa devolver
4. se ele e read-only, editor, orquestrador ou operator
5. quais especialistas existentes ele deve ou nao deve chamar

## Sinais de agent ruim

- descricao vaga como "helpful agent"
- tools demais para um papel estreito
- corpo que contradiz a descricao
- reviewer com `edit` sem necessidade
- arquiteto com `execute`, `web` e `edit` juntos por default
- orchestrator sem contrato de retorno dos subagents
- agent que parece skill, prompt file e orchestrator ao mesmo tempo

## Saida obrigatoria desta skill

1. papel do agent
2. desenho do frontmatter e por que ele foi escolhido
3. restricoes centrais
4. formato de saida esperado
5. validacao aplicada

## Arquivos de apoio

- [README local](./README.md)
- [Blueprint de agent](./references/blueprint-de-agent.md)
- [Frontmatter e descoberta](./references/frontmatter-e-descoberta.md)
- [Checklist de prontidao](./checklists/prontidao-de-agent.md)
- [Checklist de blast radius](./checklists/blast-radius-de-tools.md)
- [Pipeline de engenharia](./patterns/pipeline-de-engenharia-de-agents.md)
- [Template planner](./templates/planner.agent.template.md)
- [Template researcher](./templates/researcher.agent.template.md)
- [Template executor](./templates/executor.agent.template.md)
- [Template reviewer](./templates/reviewer.agent.template.md)
- [Template orchestrator](./templates/orchestrator.agent.template.md)