---
description: Research official guidance, community patterns, and current repository assets to design a high-confidence specialist skill for creating GitHub Copilot agents in VS Code.
model: Auto
tools: ['search/codebase', 'search/usages', 'web/fetch', 'runSubagent', 'agent']
---

# Prompt 2: pesquisar e desenhar a skill especialista em criacao de agents

Continue a partir do diagnostico produzido imediatamente antes nesta mesma sessao. Nao recomecar do zero. Use a especificacao final do Prompt 1 como contrato de trabalho.

## Objetivo

Desenhar a arquitetura da nova skill especialista em criacao de agents com base em:

- estado atual do repositorio
- pesquisa oficial do VS Code e GitHub Copilot
- sinais comunitarios relevantes
- lacunas e riscos encontrados no Prompt 1

## Missao

Produza um desenho forte o bastante para materializar a skill no Prompt 3 sem precisar improvisar durante a implementacao.

## Ordem obrigatoria

1. Releia a especificacao final gerada no Prompt 1.
2. Consulte primeiro o material local do repositorio.
3. Depois consulte documentacao oficial e referencias recentes se algum ponto do produto estiver ambiguo ou datado.
4. So depois consulte padroes comunitarios para naming, layout, templates e praticas maduras.
5. Resolva conflitos explicitamente. Oficial vence comunidade.

## O que esta skill alvo deve saber fazer

Desenhe a skill para ser especialista em criar ou evoluir:

- `.github/agents/*.agent.md`
- `README.md` de catalogo de agents
- handoffs entre agents
- restricao de tools por agent
- escolha de modelo por papel
- uso de `agents`, `agent`, `runSubagent` e fronteiras de contexto quando aplicavel
- templates, checklists e referencias para criacao segura de agents

## Eixos obrigatorios de pesquisa e desenho

1. Diferenca entre skill, custom agent, prompt file e instruction file na criacao de agents.
2. Estrutura minima de uma boa skill de criacao de agents.
3. Templates necessarios para agents de leitura, orquestracao e materializacao.
4. Regras de naming, ownership e blast radius.
5. Guardrails para evitar:
   - agent faz tudo
   - tool surface ampla demais
   - `description` fraca
   - handoffs mal definidos
   - uso incorreto de `agents` sem `agent` tool
   - claims fortes sem evidencia

## Delegacao recomendada

Use, quando fizer sentido:

- `copilot-vscode-curador-evidencias.agent.md`
- `copilot-vscode-benchmark-comunidade.agent.md`
- `copilot-vscode-arquiteto-configuracoes.agent.md`

## Entregavel obrigatorio

Responda com um blueprint em 7 blocos:

1. objetivo preciso da nova skill
2. responsabilidade e nao-responsabilidade
3. arquivos que a skill deve conter
4. estrutura interna recomendada
5. regras fortes e antipatrones
6. templates/checklists/references a criar
7. plano de materializacao para o Prompt 3

## Regra final

Termine com uma lista fechada dos arquivos que devem ser criados ou atualizados no Prompt 3. Essa lista sera a entrada de implementacao.