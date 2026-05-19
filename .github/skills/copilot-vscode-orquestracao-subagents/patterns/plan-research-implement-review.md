# Pattern: plan -> research -> implement -> review

## Sequencia recomendada

1. planner gera plano e criterios de verificacao
2. planner dispara researcher como subagent quando faltar contexto
3. implementer age so depois de receber contexto suficiente
4. reviewer audita risco, regressao e teste

## Ownership

- planner decide ordem e escopo
- researcher devolve sintese, nao rastro completo
- implementer altera codigo
- reviewer nao deveria editar por padrao

## Sinal de uso correto

- o contexto principal continua limpo e focado na decisao atual
