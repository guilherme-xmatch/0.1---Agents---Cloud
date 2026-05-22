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

Exemplo de saida boa:

- problema resumido em uma frase
- 2 ou 3 trilhas avaliadas
- principal risco ou restricao
- recomendacao provisoria em uma linha

Exemplo de saida ruim:

- dump grande de exploracao
- links ou observacoes sem priorizacao
- ausencia de recomendacao utilizavel no proximo passo

## Researcher -> Implementer

Entrada:

- sintese util, nao transcricao de exploracao
- ownership claro de arquivo ou dominio
- riscos que precisam ser preservados durante a edicao

Saida esperada:

- contexto suficiente para agir sem reabrir a pesquisa inteira
- ownership claro do dominio ou dos arquivos, quando houver edicao

## Implementer -> Reviewer

Entrada:

- mudanca realizada
- validacao executada ou faltante
- pontos de risco conhecidos

Saida esperada:

- findings de risco, regressao e cobertura
- lacunas de validacao
- aceitacao ou ressalvas

## Worker -> Orchestrator

Entrada:

- objetivo delimitado
- tools e limites operacionais coerentes com a subtarefa
- formato de retorno explicitado pelo orquestrador

Saida esperada:

- sintese curta e acionavel
- risco principal ou limitacao encontrada
- proximo passo recomendado
- sinalizacao clara se o handoff seguinte depende de approvals, MCP, web ou edit

## Regra geral

Cada handoff deve carregar apenas o minimo necessario para o papel seguinte. Se o output nao cabe em uma sintese curta, o handoff ainda esta mal desenhado.

Se o worker devolveu contexto bruto demais, o orquestrador deve consolidar ou repedir a subtarefa, em vez de propagar ruido para o resto da cadeia.