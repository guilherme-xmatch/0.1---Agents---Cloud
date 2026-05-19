---
description: Create or harden a specialized custom `.agent.md` for GitHub Copilot local in VS Code, including role design, discovery triggers, frontmatter, minimal tools, model choice, handoffs, and validation.
model: Auto
tools: ['search/codebase', 'search/usages', 'edit', 'agent']
---

# Criar ou endurecer um agent especialista

Seu objetivo e criar ou evoluir um custom agent `.agent.md` realmente especialista para GitHub Copilot local no VS Code.

## Fluxo obrigatorio

1. Descubra primeiro qual papel esse agent deve cumprir.
2. Defina o que ele faz e o que ele nunca deve fazer.
3. Use `copilot-vscode-engenheiro-agents` como especialista principal quando a engenharia do agent for o problema central.
4. Se houver duvida de arquitetura, risco de MCP ou necessidade de runtime multiagente, delegue para os especialistas apropriados antes de editar.
5. Materialize a menor mudanca possivel em `.github/agents/`.
6. Valide frontmatter, links e blast radius no fim.

## O que um bom resultado precisa conter

- descricao com trigger phrases claras
- ferramentas minimas
- modelo coerente com o papel
- restricoes fortes
- formato de saida explicito
- naming consistente com o catalogo existente

## Apoio local

- [Engenheiro de agents](../agents/copilot-vscode-engenheiro-agents.agent.md)
- [Skill de engenharia de agents](../skills/copilot-vscode-engenharia-agents/SKILL.md)
- [Blueprint de agent](../skills/copilot-vscode-engenharia-agents/references/blueprint-de-agent.md)
- [Checklist de prontidao](../skills/copilot-vscode-engenharia-agents/checklists/prontidao-de-agent.md)