---
name: copilot-vscode-arquitetura-local
description: Desenha ou revisa a arquitetura local do GitHub Copilot no VS Code. Use quando precisar decidir entre custom agents, subagents, prompt files, instruction files, skills, hooks, MCP, memoria, modelos, permissoes e tool sets.
---

# Copilot VS Code: arquitetura local

Use esta skill quando:

- o pedido for "qual mecanismo usar?"
- houver duvida entre `copilot-instructions.md`, `*.instructions.md`, `*.prompt.md`, `*.agent.md`, `SKILL.md`, hooks, MCP ou memoria
- voce precisar propor uma arquitetura local sustentavel para individuo ou time

Nao use esta skill quando:

- o trabalho principal for editar um arquivo especifico de customizacao sem duvida arquitetural
- a tarefa for auditoria de risco de um setup ja existente, caso em que `copilot-vscode-auditoria-setup` e mais precisa
- a necessidade central for integracao externa, approvals ou blast radius de MCP, caso em que `copilot-vscode-mcp-governanca` deve prevalecer
- o foco for so rollout, ownership e faseamento, caso em que `copilot-vscode-playbook-rollout` e mais especializada

Matriz de decisao principal:

- baseline global do repo: `.github/copilot-instructions.md`
- regra condicional por stack, framework ou pasta: `.github/instructions/*.instructions.md`
- tarefa reutilizavel sob demanda: `.github/prompts/*.prompt.md`
- persona persistente com modelo, tools e handoffs proprios: `.github/agents/*.agent.md`
- capacidade portavel com scripts, exemplos e recursos: `.github/skills/**/SKILL.md`
- automacao deterministica de lifecycle: `.github/hooks/*.json`
- integracao externa e novas tools/resources/prompts: `.vscode/mcp.json`
- continuidade local entre sessoes: `/memories/`, `/memories/repo/`, `/memories/session/`
- pesquisa lateral com isolamento de contexto: subagents

Fluxo de trabalho:

1. Identifique o comportamento desejado.
2. Descubra se o problema e de politica, tarefa, persona, automacao, integracao externa, memoria ou orquestracao.
3. Proponha a menor combinacao de superficies capaz de resolver o caso.
4. Defina limites de tools, modelos e aprovacoes por papel.
5. Liste tradeoffs, riscos e anti-padroes.

Regras fortes:

- Prefira `.agent.md` ao formato legado `.chatmode.md` em setups novos.
- Trate `implementer` como padrao de custom agent, nao como primitive oficial garantida do produto.
- Separe planejamento, execucao e revisao quando a mudanca for media ou grande.
- Reduza o conjunto de tools antes de confiar apenas em instrucoes textuais.
- Mantenha o runtime ancorado nas superficies canonicas e empurre profundidade para documentacao lateral ou subpastas internas de skill.
- Documentacao oficial vence a comunidade quando houver conflito.

Entregaveis esperados:

- mapa de superficies recomendadas
- estrutura de pastas sugerida
- envelope de models/tools/approvals
- riscos e restricoes
- nivel de confianca da recomendacao

Entradas que esta skill deve identificar antes de recomendar:

1. o problema e de politica, tarefa, persona, integracao, automacao, memoria ou orquestracao
2. o escopo e pessoal, de workspace, de time ou multi-repo
3. o runtime precisa ser read-only, editavel ou integrado a sistemas externos
4. a decisao depende de handoff entre papeis ou pode ficar em uma unica superficie

Fronteiras fortes:

- nao trate `implementer` como primitive oficial do produto sem prova atual
- nao promova `tool set` a conceito formal se o pedido estiver falando apenas de selecao de tools e approvals
- nao use memoria para resolver ausencia de policy versionada
- nao recomende hooks ou MCP quando instruction, prompt file ou skill forem suficientes

Formato de resposta recomendado:

1. problema arquitetural
2. superficies candidatas
3. escolha principal e por que ela vence
4. o que fica explicitamente fora da recomendacao
5. tradeoffs e anti-padroes evitados

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [Fontes e metodologia](../../../docs/13-github-copilot-vscode-local/fontes-e-metodologia.md)
- [Topologia de runtime e pastas](../../../docs/13-github-copilot-vscode-local/topologia-de-runtime-e-pastas.md)
- [Fleet de agents e handoffs](../../../docs/13-github-copilot-vscode-local/fleet-de-agents-e-handoffs.md)
- [README local](./README.md)
- [Matriz curta de superficies](./references/matriz-de-superficies.md)
- [Checklist de revisao arquitetural](./checklists/revisao-arquitetural.md)
