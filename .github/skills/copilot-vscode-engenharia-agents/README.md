# Copilot VS Code: engenharia de agents

Esta pasta e o nucleo especialista do repositorio para criacao de agents `.agent.md` no GitHub Copilot local do VS Code.

## O que torna esta skill diferente

Ela nao trata customizacao local em geral. Ela existe para desenhar agents realmente bons:

- papel unico e verificavel
- descricao com gatilhos de descoberta reais
- tool surface minima
- modelo coerente com o papel
- handoffs e subagents com fronteiras claras
- corpo do agent com restricoes e output format acionavel

## Estrutura interna

- [SKILL.md](./SKILL.md)
- [references/blueprint-de-agent.md](./references/blueprint-de-agent.md)
- [references/frontmatter-e-descoberta.md](./references/frontmatter-e-descoberta.md)
- [checklists/prontidao-de-agent.md](./checklists/prontidao-de-agent.md)
- [checklists/blast-radius-de-tools.md](./checklists/blast-radius-de-tools.md)
- [patterns/pipeline-de-engenharia-de-agents.md](./patterns/pipeline-de-engenharia-de-agents.md)
- [templates/planner.agent.template.md](./templates/planner.agent.template.md)
- [templates/researcher.agent.template.md](./templates/researcher.agent.template.md)
- [templates/executor.agent.template.md](./templates/executor.agent.template.md)
- [templates/reviewer.agent.template.md](./templates/reviewer.agent.template.md)
- [templates/orchestrator.agent.template.md](./templates/orchestrator.agent.template.md)

## Quando usar esta pasta

- quando o problema central e criar um novo agent
- quando um agent atual esta generico ou perigoso demais
- quando o repositorio precisa de uma fabrica consistente de agents especialistas

## Bases principais

- [Catalogo de agents](../../agents/README.md)
- [Catalogo de skills](../README.md)
- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)