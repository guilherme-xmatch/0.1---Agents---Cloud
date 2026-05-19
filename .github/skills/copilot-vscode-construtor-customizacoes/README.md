# Copilot VS Code: construtor de customizacoes

Esta pasta organiza a skill de construcao em torno de mapeamento de arquivos e esqueletos de artefatos.

Quando o desafio principal for desenhar um `*.agent.md` realmente especialista, com definicao de papel, triggers, tools, modelos, handoffs e restricoes, use a skill dedicada [copilot-vscode-engenharia-agents](../copilot-vscode-engenharia-agents/SKILL.md).

Camadas internas:

- `references/`: decide onde cada configuracao deve ser materializada
- `templates/`: esqueletos minimos para novos artefatos do repositorio

Arquivos principais:

- [SKILL.md](./SKILL.md)
- [references/mapeamento-de-arquivos.md](./references/mapeamento-de-arquivos.md)
- [templates/layout-minimo.template.md](./templates/layout-minimo.template.md)

Base externa principal:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)