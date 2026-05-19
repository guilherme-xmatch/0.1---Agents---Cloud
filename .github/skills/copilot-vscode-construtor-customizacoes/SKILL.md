---
name: copilot-vscode-construtor-customizacoes
description: Cria ou evolui customizacoes locais do GitHub Copilot no VS Code dentro do repositorio. Use quando precisar materializar `*.prompt.md`, `*.instructions.md`, `copilot-instructions.md`, `SKILL.md`, hooks, `.vscode/mcp.json` ou ajustes estruturais; para engenharia profunda de `.agent.md`, prefira a skill dedicada de engenharia de agents.
---

# Copilot VS Code: construtor de customizacoes

Use esta skill quando:

- o usuario pedir para criar ou editar arquivos reais de customizacao
- voce precisar transformar um guideline arquitetural em artefatos concretos do repo
- o time quiser migrar de um setup improvisado para um layout oficial

Nao use esta skill quando:

- a duvida central ainda for qual mecanismo escolher, sem decisao arquitetural minima
- o pedido for somente auditoria, benchmarking ou rollout sem materializacao de arquivos
- a necessidade principal envolver validacao de risco de MCP, approvals ou blast radius, caso em que `copilot-vscode-mcp-governanca` deve liderar
- o desafio principal for projetar ou endurecer um custom agent realmente especialista em `.agent.md`, com gatilhos de descoberta, fronteiras, tools, modelos, handoffs e subagents

Localizacao padrao a respeitar:

- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `.github/prompts/*.prompt.md`
- `.github/agents/*.agent.md`
- `.github/skills/**/SKILL.md`
- `.github/hooks/*.json`
- `.vscode/mcp.json`

Fluxo de trabalho:

1. Inventarie o que ja existe em `.github/` e `.vscode/`.
2. Escolha a menor quantidade de arquivos necessaria para resolver o pedido.
3. Preserve ownership claro entre planner, researcher, implementer, reviewer e debugger quando criar agents.
4. Valide se o arquivo esta no lugar certo e com naming consistente.
5. Se houver MCP, avalie se o config deve ser ativo, `.sample` ou `.template`.

Regras fortes verificadas:

- Se um custom agent usa a propriedade `agents`, inclua a tool `agent` no `tools` desse agente.
- Se um prompt file precisar induzir subagents, inclua `runSubagent` ou `agent` no `tools` frontmatter.
- Quando `tools` existirem no custom agent e no prompt file, os tools do prompt file tem precedencia.
- Nao introduza `.chatmode.md` novo; migre para `.agent.md`.
- Nao grave segredos em `mcp.json` compartilhado; prefira `inputs`.

Entradas minimas antes de editar:

1. qual superficie sera criada ou alterada
2. qual problema de configuracao ela resolve
3. qual e o escopo: workspace, perfil ou template
4. qual e o blast radius aceitavel de tools e automacao

Saida obrigatoria desta skill:

1. artefatos criados ou alterados
2. por que cada arquivo foi usado
3. validacao aplicada
4. riscos residuais ou proximos passos

Checklist antes de concluir:

1. O arquivo certo foi usado para o problema certo.
2. O naming segue a finalidade do artefato.
3. O blast radius de tools e MCP e o minimo possivel.
4. Os links ou referencias locais apontam para arquivos existentes.
5. Existe um passo de validacao apos a edicao.

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [README local](./README.md)
- [Mapeamento de arquivos](./references/mapeamento-de-arquivos.md)
- [Template de layout minimo](./templates/layout-minimo.template.md)
- [Skill de engenharia de agents](../copilot-vscode-engenharia-agents/SKILL.md)
