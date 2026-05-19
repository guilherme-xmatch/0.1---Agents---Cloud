---
name: copilot-vscode-playbook-rollout
description: Planeja a adocao e a evolucao de GitHub Copilot local no VS Code para individuos ou times. Use quando precisar transformar a arquitetura em rollout, ownership, fases de maturidade, politica de tools, memoria e governanca operacional.
---

# Copilot VS Code: playbook de rollout

Use esta skill quando:

- o usuario quiser padronizar o uso do Copilot no time
- houver necessidade de rollout por fases e ownership claro
- a discussao sair de arquivos isolados e passar para governanca operacional

Fases recomendadas:

1. `Baseline seguro`
   - `copilot-instructions.md`
   - 2 ou 3 `*.instructions.md`
   - 2 ou 3 prompt files
   - `Default Approvals`
2. `Especializacao`
   - planner, reviewer e implementer
   - uso inicial de subagents
   - pelo menos 1 skill de alto valor
3. `Integracao e enforcement`
   - MCP compartilhado ou `.sample/.template`
   - hooks deterministas de alto valor
   - revisao de tool approvals
4. `Governanca e escala`
   - ownership formal
   - memoria governada
   - politica de modelos e premium requests
   - padroes mais estaveis empacotados como assets do time

Fluxo de trabalho:

1. Descubra a maturidade atual.
2. Escolha a fase-alvo imediatamente seguinte.
3. Defina os artefatos minimos para essa fase.
4. Defina quem e dono de:
   - instructions
   - agents
   - skills
   - hooks
   - MCP
   - memoria de repositorio
5. Defina criterio de promocao para a fase seguinte.

Regras fortes:

- Nao escale para MCP amplo e hooks agressivos antes de ter baseline seguro.
- Separar ownership de planejamento, execucao e revisao reduz risco.
- O que for preferencia pessoal vai para perfil ou user memory, nao para o repo.
- Cada fase precisa de metricas simples de sucesso e rollback claro.

Entregaveis esperados:

- fase atual
- fase alvo
- artefatos a criar ou ajustar
- ownership
- politica de tools/models/approvals
- criterios de sucesso e proximos passos

Arquivo de apoio principal:

- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
