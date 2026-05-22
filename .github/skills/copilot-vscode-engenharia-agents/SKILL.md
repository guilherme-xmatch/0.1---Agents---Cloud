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

- a superficie certa ainda nao estiver decidida, caso em que `copilot-vscode-arquitetura-local` deve liderar
- o desenho do agent ja estiver fechado e o trabalho principal for materializar arquivos no repositorio, caso em que `copilot-vscode-construtor-customizacoes` deve assumir
- o problema principal for MCP, approvals ou blast radius de integracoes externas
- a tarefa principal for so orquestrar um workflow multiagente sem criar ou endurecer `.agent.md`

## Missao

Projetar agents extremamente especialistas, com uma unica responsabilidade central, descricao forte para descoberta, tool surface minima, fronteiras claras e contrato de saida que permita delegacao segura.

## Regra de lideranca

- se o problema central e `.agent.md`, esta skill lidera
- se o problema central e outra superficie, esta skill so apoia ou sai da frente
- depois que o desenho do agent estiver fechado, a materializacao pode passar para `copilot-vscode-construtor-customizacoes`

## Principios obrigatorios

- um papel por agent
- descricao e a superficie de descoberta: ela precisa conter os gatilhos reais de uso
- tools minimas antes de qualquer ganho de conveniencia
- se o agent usa `agents`, ele precisa da tool `agent`
- read-only por default para planner, researcher, auditor, benchmarker e arquiteto
- `edit` so para agents cujo trabalho principal e materializar artefatos
- `execute`, `web` e MCP so entram com justificativa explicita
- o contrato de saida precisa ser explicito antes de delegar ou escalar autonomia
- use o catalogo atual antes de criar um agent novo
- nao introduza `.chatmode.md` novo

## Fluxo de trabalho

1. Confirme que `.agent.md` e a superficie correta para o problema.
2. Defina a missao do agent em uma frase verificavel.
3. Escolha a classe do agent:
   - planner
   - researcher
   - executor
   - reviewer
   - auditor
   - orchestrator
   - operator
4. Escreva a descricao com palavras que permitam descoberta por delegacao e deixem a anti-missao implicita.
5. Defina o menor conjunto de tools e o modelo adequado.
6. Decida se ele deve ser chamado diretamente, por delegacao ou pelos dois caminhos.
7. Se houver subagents permitidos, restrinja explicitamente o campo `agents` e escreva o contrato de retorno.
8. Escreva corpo com restricoes, abordagem e formato de saida.
9. Valide frontmatter, naming, ownership, links e blast radius.
10. Se o desenho for aprovado e a tarefa pedir edicao real de arquivos, passe a materializacao para o construtor.

## Entradas minimas antes de criar um agent

1. problema exato que o agent resolve
2. o que ele nunca deve fazer
3. que artefato ou output precisa devolver
4. se ele e read-only, editor, orquestrador ou operator
5. quais especialistas existentes ele deve ou nao deve chamar
6. qual e o blast radius aceitavel para tools e autonomia

## Sinais de agent ruim

- descricao vaga como "helpful agent"
- tools demais para um papel estreito
- corpo que contradiz a descricao
- reviewer com `edit` sem necessidade
- arquiteto com `execute`, `web` e `edit` juntos por default
- orchestrator sem contrato de retorno dos subagents
- agent novo que duplica um papel ja coberto pelo catalogo atual
- agent que parece skill, prompt file e orchestrator ao mesmo tempo

## Saida obrigatoria desta skill

1. papel do agent
2. desenho do frontmatter e por que ele foi escolhido
3. restricoes centrais e anti-missao
4. tools, modelo e handoffs escolhidos
5. ownership e risco de overlap
6. validacao aplicada

## Arquivos de apoio

- [README local](./README.md)
- [Blueprint de agent](./references/blueprint-de-agent.md)
- [Frontmatter e descoberta](./references/frontmatter-e-descoberta.md)
- [Matriz de entrada e lideranca](./references/matriz-de-entrada-e-lideranca.md)
- [Contratos de saida por papel](./references/contratos-de-saida-por-papel.md)
- [Checklist de prontidao](./checklists/prontidao-de-agent.md)
- [Checklist de blast radius](./checklists/blast-radius-de-tools.md)
- [Checklist de ownership e overlap](./checklists/ownership-e-overlap.md)
- [Checklist de validacao pos-criacao](./checklists/validacao-pos-criacao.md)
- [Pipeline de engenharia](./patterns/pipeline-de-engenharia-de-agents.md)
- [Template base](./templates/_TEMPLATE.agent.md)
- [Template planner](./templates/planner.agent.template.md)
- [Template researcher](./templates/researcher.agent.template.md)
- [Template executor](./templates/executor.agent.template.md)
- [Template reviewer](./templates/reviewer.agent.template.md)
- [Template orchestrator](./templates/orchestrator.agent.template.md)
- [Template auditor](./templates/auditor.agent.template.md)
- [Template operator](./templates/operator.agent.template.md)
- [Casos canonicos](./examples/casos-canonicos-de-agent.md)
- [Guia de falhas](./troubleshooting/guia-de-falhas-de-agents.md)