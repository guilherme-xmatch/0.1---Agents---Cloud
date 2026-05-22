# Matriz de entrada e lideranca

Regra curta:

- se o problema central e `.agent.md`, esta skill lidera
- se a superficie ainda nao esta decidida, a skill de arquitetura lidera
- se o desenho ja esta fechado e falta materializar arquivos, o construtor assume

| Situacao central | Lidera | Esta skill entra como | Sinal de handoff |
| --- | --- | --- | --- |
| ainda nao esta claro se o caso pede agent, prompt file, instruction ou skill | `copilot-vscode-arquitetura-local` | apoio tecnico | quando `.agent.md` virar a escolha principal |
| criar um agent novo ou endurecer um agent existente | `copilot-vscode-engenharia-agents` | lideranca principal | quando o desenho estiver pronto para materializacao |
| workflow multiagente sem criar ou revisar `.agent.md` | `copilot-vscode-orquestracao-subagents` | apoio para contratos de handoff | quando surgir a necessidade de um novo specialist persistente |
| o risco principal esta em MCP, approvals ou blast radius de tool source | `copilot-vscode-mcp-governanca` | apoio de design do agent | quando o envelope de tools do agent depender dessa decisao |
| o desenho do agent ja esta fechado e o pedido e editar arquivos reais | `copilot-vscode-construtor-customizacoes` | referencia de design | quando a tarefa deixar de ser sobre papel e passar a ser sobre arquivos |

Checklist rapido:

- o problema central e o papel do agent ou o runtime inteiro?
- a saida desejada e um desenho de `.agent.md` ou uma edicao concreta do repo?
- ja existe um agent no catalogo cobrindo pelo menos 80 por cento do papel?