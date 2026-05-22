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

Ela lidera quando o problema central e `.agent.md`. Quando a arquitetura ainda esta aberta, a skill de arquitetura lidera. Quando o desenho ja esta fechado e falta materializar arquivos, o construtor assume.

## Estrutura interna

- [SKILL.md](./SKILL.md)
- [references/blueprint-de-agent.md](./references/blueprint-de-agent.md)
- [references/frontmatter-e-descoberta.md](./references/frontmatter-e-descoberta.md)
- [references/matriz-de-entrada-e-lideranca.md](./references/matriz-de-entrada-e-lideranca.md)
- [references/contratos-de-saida-por-papel.md](./references/contratos-de-saida-por-papel.md)
- [checklists/prontidao-de-agent.md](./checklists/prontidao-de-agent.md)
- [checklists/blast-radius-de-tools.md](./checklists/blast-radius-de-tools.md)
- [checklists/ownership-e-overlap.md](./checklists/ownership-e-overlap.md)
- [checklists/validacao-pos-criacao.md](./checklists/validacao-pos-criacao.md)
- [patterns/pipeline-de-engenharia-de-agents.md](./patterns/pipeline-de-engenharia-de-agents.md)
- [templates/_TEMPLATE.agent.md](./templates/_TEMPLATE.agent.md)
- [templates/planner.agent.template.md](./templates/planner.agent.template.md)
- [templates/researcher.agent.template.md](./templates/researcher.agent.template.md)
- [templates/executor.agent.template.md](./templates/executor.agent.template.md)
- [templates/reviewer.agent.template.md](./templates/reviewer.agent.template.md)
- [templates/orchestrator.agent.template.md](./templates/orchestrator.agent.template.md)
- [templates/auditor.agent.template.md](./templates/auditor.agent.template.md)
- [templates/operator.agent.template.md](./templates/operator.agent.template.md)
- [examples/casos-canonicos-de-agent.md](./examples/casos-canonicos-de-agent.md)
- [troubleshooting/guia-de-falhas-de-agents.md](./troubleshooting/guia-de-falhas-de-agents.md)

## Quando usar esta pasta

- quando o problema central e criar um novo agent
- quando um agent atual esta generico ou perigoso demais
- quando o repositorio precisa de uma fabrica consistente de agents especialistas

## O que ela nao resolve sozinha

- escolher a superficie correta quando a decisao ainda esta aberta
- materializar customizacoes genericas fora de `.agent.md`
- tratar MCP, approvals ou rollout como problema principal

## Fluxo recomendado

1. use a matriz de entrada para confirmar que `.agent.md` e a superficie certa
2. desenhe papel, descricao, tools, modelo e handoffs com as referencias
3. passe pelos checklists antes de considerar o agent pronto
4. consulte os exemplos e o guia de falhas se houver duvida de discovery, overlap ou blast radius
5. se a tarefa for editar o repositorio, materialize com o construtor

## Bases principais

- [Catalogo de agents](../../agents/README.md)
- [Catalogo de skills](../README.md)
- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Sinais avancados desde 2026-04-01](../../../docs/13-github-copilot-vscode-local/sinais-avancados-desde-2026-04-01.md)
- [Custom agents: leitura avancada desde 2026-04-01](../../../docs/13-github-copilot-vscode-local/custom-agents-avancados-desde-2026-04-01.md)
- [Topologia de runtime e pastas](../../../docs/13-github-copilot-vscode-local/topologia-de-runtime-e-pastas.md)
- [Fleet de agents e handoffs](../../../docs/13-github-copilot-vscode-local/fleet-de-agents-e-handoffs.md)
- [Skill de arquitetura local](../copilot-vscode-arquitetura-local/SKILL.md)
- [Skill de construcao](../copilot-vscode-construtor-customizacoes/SKILL.md)