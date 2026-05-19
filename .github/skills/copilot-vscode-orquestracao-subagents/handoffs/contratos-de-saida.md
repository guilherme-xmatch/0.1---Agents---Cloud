# Contratos de saida entre papeis

## Planner -> Researcher

Entrada:

- problema bem delimitado
- recortes ou trilhas a explorar
- criterios de verificacao ou de comparacao

Saida esperada:

- sintese curta
- opcoes ou riscos principais
- recomendacao provisoria

## Researcher -> Implementer

Entrada:

- sintese util, nao transcricao de exploracao
- ownership claro de arquivo ou dominio
- riscos que precisam ser preservados durante a edicao

Saida esperada:

- contexto suficiente para agir sem reabrir a pesquisa inteira

## Implementer -> Reviewer

Entrada:

- mudanca realizada
- validacao executada ou faltante
- pontos de risco conhecidos

Saida esperada:

- findings de risco, regressao e cobertura
- lacunas de validacao
- aceitacao ou ressalvas

## Regra geral

Cada handoff deve carregar apenas o minimo necessario para o papel seguinte. Se o output nao cabe em uma sintese curta, o handoff ainda esta mal desenhado.