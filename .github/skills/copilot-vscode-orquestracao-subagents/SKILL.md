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

Nao use esta skill quando:

- a tarefa puder ficar inteira em um unico agente ou prompt file
- o problema principal for so escolher o mecanismo correto, sem necessidade de runtime multiagente
- a equipe ainda nao definiu ownership minimo de arquivos e papeis

Fatos verificados para usar:

- subagents sao context-isolated e normalmente agent-initiated
- o agente principal precisa da tool `runSubagent` para invocar subagents
- nested subagents exigem `setting(chat.subagents.allowInvocationsFromSubagents)`
- nested subagents ainda podem apresentar rugosidade real de runtime; nao trate recursao como default seguro
- custom agents podem rodar como subagents e sobrescrever model, tools e instrucoes herdadas
- o Plan agent pode ser acessado por `/plan` e persiste `plan.md` em `/memories/session/plan.md`
- custo, billing e modelo efetivo do worker podem divergir do que o frontmatter sugere; orchestrators precisam tratar isso como risco operacional

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
6. Valide o output devolvido por cada worker antes de seguir para o proximo handoff.

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

Entradas minimas que esta skill deve determinar:

1. quais subtarefas realmente precisam de contexto isolado
2. quais papeis podem ser read-only
3. qual output sintetico cada subagent deve devolver
4. quais arquivos ou dominios precisam de ownership exclusivo

Entregaveis esperados:

- diagrama ou sequencia de handoffs
- lista de agents/subagents envolvidos
- modelo e tools por papel
- riscos de nested invocation, billing ou approvals quando houver
- criterios de aprovacao e validacao

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [README local](./README.md)
- [Pattern plan research implement review](./patterns/plan-research-implement-review.md)
- [Checklist de limites para subagents](./checklists/limites-de-subagents.md)
- [Contratos de saida](./handoffs/contratos-de-saida.md)
