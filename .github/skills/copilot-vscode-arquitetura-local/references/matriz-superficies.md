# Matriz de superficies locais

| Problema | Superficie primaria | Superficie de apoio |
| --- | --- | --- |
| regra global do repo | `copilot-instructions.md` | `*.instructions.md` |
| regra por stack ou diretorio | `*.instructions.md` | prompt file |
| tarefa sob demanda | `*.prompt.md` | skill |
| papel persistente | `*.agent.md` | subagents |
| capacidade com assets | `SKILL.md` | prompt file |
| automacao deterministica | hook | approvals |
| integracao externa | MCP | hook ou prompt file |
| pesquisa lateral isolada | subagent | custom agent como worker |
| continuidade local | memory | plan.md de sessao |

Pergunta orientadora:

- isto e politica, tarefa, persona, capacidade, automacao, integracao ou memoria?
