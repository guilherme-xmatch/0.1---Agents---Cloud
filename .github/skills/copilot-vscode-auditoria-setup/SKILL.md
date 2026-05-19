---
name: copilot-vscode-auditoria-setup
description: Audita um setup local do GitHub Copilot no VS Code e aponta riscos, lacunas, anti-padroes e proximos passos. Use quando o repo ja possui customizacoes e voce precisa revisar arquitetura, seguranca, consistencia ou maturidade.
---

# Copilot VS Code: auditoria de setup

Use esta skill quando:

- o usuario pedir review do setup local
- houver suspeita de excesso de contexto, tools demais ou conflito entre superficies
- o repo precisar de um plano de saneamento

Fluxo de auditoria:

1. Inventarie:
   - `.github/copilot-instructions.md`
   - `.github/instructions/`
   - `.github/prompts/`
   - `.github/agents/`
   - `.github/skills/`
   - `.github/hooks/`
   - `.vscode/mcp.json`
2. Classifique cada artefato entre politica, tarefa, persona, automacao, integracao externa e memoria.
3. Compare com o playbook de maturidade do repo.
4. Relate findings primeiro, ordenados por severidade.
5. Separe o que e verificado, inferencia e hipotese.

Anti-padroes a procurar:

- tudo entulhado em `copilot-instructions.md`
- um unico agent com web, MCP, edicao e terminal sem restricao clara
- `Bypass Approvals` ou `Autopilot` como baseline do time
- novos arquivos `.chatmode.md` em vez de `.agent.md`
- segredos ou `env` sensivel em config compartilhado de MCP
- hooks lentos, opacos ou acoplados a rede fragil
- memoria substituindo documentacao versionada do repo
- multiplos agents editando os mesmos arquivos sem ownership claro

Formato de saida recomendado:

1. Findings principais.
2. Lacunas e riscos.
3. Maturidade atual.
4. Correcao minima recomendada.
5. Proximos passos por prioridade.

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Padroes comunitarios](../../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
