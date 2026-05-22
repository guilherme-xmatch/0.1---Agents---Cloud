# Checklist de limites para subagents

- a subtarefa e realmente independente?
- existe ownership claro de arquivo antes da fase de edicao?
- o resultado esperado do subagent foi definido em uma sintese curta?
- o paralelismo reduz tempo sem aumentar conflito?
- o contexto principal vai receber apenas o necessario na volta?
- nested subagents sao realmente necessarios, ou fan-out simples resolve melhor?
- se houver nested invocation, o setting necessario e a rugosidade do runtime foram considerados?
- billing, custo ou modelo efetivo do worker podem mudar a decisao de usar este handoff?
- o worker depende de approvals, MCP, web ou git que ampliem o blast radius da cadeia?