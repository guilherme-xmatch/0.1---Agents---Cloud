# Pattern: plan -> research -> implement -> review

## Quando usar

Use este pattern quando a tarefa atravessa varias camadas e o contexto principal nao deve virar deposito de pesquisa bruta.

## Sequencia recomendada

1. `planner` define o problema, o escopo e os criterios de verificacao.
2. `researcher` faz discovery lateral e devolve sintese curta e orientada a decisao.
3. `implementer` so edita depois que o contexto fica estavel e o ownership esta claro.
4. `reviewer` audita risco, regressao e cobertura.

## Ownership

- `planner` decide ordem e escopo
- `researcher` devolve sintese, nao rastro completo
- `implementer` altera codigo
- `reviewer` nao deveria editar por padrao

## Anti-padroes

- `researcher` editar como atalho
- `implementer` comecar antes de o plano estabilizar
- `reviewer` atuar como selo automatico sem contexto suficiente
- paralelismo em subtarefas que disputam os mesmos arquivos

## Sinal de uso correto

- o contexto principal continua limpo e focado na decisao atual
