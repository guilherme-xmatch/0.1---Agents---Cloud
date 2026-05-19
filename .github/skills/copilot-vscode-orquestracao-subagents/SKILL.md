---
name: copilot-vscode-orquestracao-subagents
description: Desenha workflows com Plan agent, subagents, handoffs e execucao paralela no VS Code. Use quando precisar dividir pesquisa, planejamento, implementacao e revisao sem poluir o contexto principal.
---

# Copilot VS Code: orquestracao com subagents

Use esta skill quando:

- a tarefa pedir plan-first
- houver pesquisa lateral ou analise paralela demais para ficar no contexto principal
- for necessario separar planner, researcher, implementer e reviewer
- o usuario quiser handoffs claros entre agentes

Fatos verificados para usar:

- subagents sao context-isolated e normalmente agent-initiated
- o agente principal precisa da tool `runSubagent` para invocar subagents
- nested subagents exigem `setting(chat.subagents.allowInvocationsFromSubagents)`
- custom agents podem rodar como subagents e sobrescrever model, tools e instrucoes herdadas
- o Plan agent pode ser acessado por `/plan` e persiste `plan.md` em `/memories/session/plan.md`

Fluxo de desenho recomendado:

1. Separe a tarefa entre planejamento, pesquisa, execucao e revisao.
2. Marque o que deve ficar no contexto principal e o que deve ir para contexto isolado.
3. Para cada subtask, decida:
   - agente padrao ou custom agent
   - modelo esperado
   - tools minimas
   - resultado sintetico esperado na volta
4. Use paralelismo apenas quando as subtarefas forem independentes.
5. Defina handoffs e ownership de arquivo antes da fase de implementacao.

Padroes fortes:

- planner gera plano e criterios de verificacao
- researcher faz discovery e retorna sintese
- implementer altera codigo so depois de contexto minimamente estavel
- reviewer audita risco, regressao e cobertura

Evite:

- abrir subagent para tarefas triviais
- colocar subagents para editar os mesmos arquivos sem ownership claro
- depender de nesting recursivo sem necessidade real
- usar prompts vagos como substituto de contrato de saida

Entregaveis esperados:

- diagrama ou sequencia de handoffs
- lista de agents/subagents envolvidos
- modelo e tools por papel
- criterios de aprovacao e validacao

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
