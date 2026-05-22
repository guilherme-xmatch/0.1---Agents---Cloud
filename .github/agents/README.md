# Catalogo de agents especialistas em GitHub Copilot

Esta pasta concentra os agents especializados do repositorio para GitHub Copilot local no VS Code.

## Convencoes

- cada agent cobre um dominio estreito e com fronteiras claras
- o conjunto de tools e o minimo necessario para aquele papel
- agents de leitura nao editam arquivos
- o agent de construcao e o unico pensado para materializar customizacoes diretamente
- o agent de orquestracao existe para combinar especialistas sem poluir o contexto principal

## Catalogo

- [copilot-vscode-arquiteto-configuracoes.agent.md](./copilot-vscode-arquiteto-configuracoes.agent.md)
- [copilot-vscode-curador-evidencias.agent.md](./copilot-vscode-curador-evidencias.agent.md)
- [copilot-vscode-engenheiro-agents.agent.md](./copilot-vscode-engenheiro-agents.agent.md)
- [copilot-vscode-engenheiro-customizacoes.agent.md](./copilot-vscode-engenheiro-customizacoes.agent.md)
- [copilot-vscode-orquestrador-subagents.agent.md](./copilot-vscode-orquestrador-subagents.agent.md)
- [copilot-vscode-governador-mcp.agent.md](./copilot-vscode-governador-mcp.agent.md)
- [copilot-vscode-auditor-setup.agent.md](./copilot-vscode-auditor-setup.agent.md)
- [copilot-vscode-benchmark-comunidade.agent.md](./copilot-vscode-benchmark-comunidade.agent.md)
- [copilot-vscode-planejador-rollout.agent.md](./copilot-vscode-planejador-rollout.agent.md)

## Mapeamento com a biblioteca de skills

- arquitetura local -> [copilot-vscode-arquitetura-local](../skills/copilot-vscode-arquitetura-local/SKILL.md)
- fontes e evidencias -> [copilot-vscode-fontes-e-evidencias](../skills/copilot-vscode-fontes-e-evidencias/SKILL.md)
- engenharia de agents -> [copilot-vscode-engenharia-agents](../skills/copilot-vscode-engenharia-agents/SKILL.md)
- construtor -> [copilot-vscode-construtor-customizacoes](../skills/copilot-vscode-construtor-customizacoes/SKILL.md)
- orquestracao -> [copilot-vscode-orquestracao-subagents](../skills/copilot-vscode-orquestracao-subagents/SKILL.md)
- MCP e governanca -> [copilot-vscode-mcp-governanca](../skills/copilot-vscode-mcp-governanca/SKILL.md)
- auditoria -> [copilot-vscode-auditoria-setup](../skills/copilot-vscode-auditoria-setup/SKILL.md)
- comunidade -> [copilot-vscode-padroes-comunidade](../skills/copilot-vscode-padroes-comunidade/SKILL.md)
- rollout -> [copilot-vscode-playbook-rollout](../skills/copilot-vscode-playbook-rollout/SKILL.md)

## Regra de especializacao

- use [copilot-vscode-engenheiro-agents.agent.md](./copilot-vscode-engenheiro-agents.agent.md) quando o problema principal for desenhar, endurecer ou revisar o papel, o frontmatter e as fronteiras de um `.agent.md`
- use [copilot-vscode-engenheiro-customizacoes.agent.md](./copilot-vscode-engenheiro-customizacoes.agent.md) para instructions, prompts, skills, hooks e customizacoes locais genericas

Leitura pratica dessa fronteira:

- o engenheiro de agents fecha papel, descricao, tools, modelo, handoffs e contrato de saida
- o engenheiro de customizacoes materializa arquivos reais quando o desenho aprovado precisar editar o repositorio

## Fleet e handoffs

Leituras canônicas para a topologia atual:

- [Topologia de runtime e pastas](../../docs/13-github-copilot-vscode-local/topologia-de-runtime-e-pastas.md)
- [Fleet de agents e handoffs](../../docs/13-github-copilot-vscode-local/fleet-de-agents-e-handoffs.md)

Heurísticas fortes do catálogo atual:

- `copilot-vscode-orquestrador-subagents` é o pivot natural de delegação, porque é o único agent que expõe a tool `agent`
- `copilot-vscode-engenheiro-customizacoes` é o agent certo para materialização, porque é o único com `edit`
- arquitetura, auditoria e governança permanecem read-only por default

Uso recomendado:

1. arquitetura primeiro
2. evidência e governança quando houver dúvida real
3. construção só depois de fechar fronteiras mínimas
4. auditoria para fechar o loop quando houver risco estrutural