# Frontmatter e descoberta

## Regras fortes

- `description` e a principal superficie de descoberta
- se o agent usa `agents`, inclua a tool `agent`
- `user-invocable: false` e util para workers internos
- `tools: []` so faz sentido para agentes conversacionais ou de sintese sem leitura local
- `model` deve refletir o tipo de trabalho, nao apenas a preferencia pessoal

## Gatilhos bons de descricao

- mencione o problema, a superficie e o tipo de output
- inclua palavras que um orchestrator realmente usaria

## Gatilhos ruins

- "helpful agent"
- "general coding assistant"
- descricoes sem contexto local, sem trigger phrase e sem dominio claro