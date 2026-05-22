# Contratos de saida por papel

Todo agent criado por esta skill deve devolver uma resposta que o chamador consiga usar sem reinterpretar o papel inteiro do worker.

| Papel | Envelope padrao | Deve devolver |
| --- | --- | --- |
| planner | `read`, `search` | problema, plano, riscos, criterios de verificacao |
| researcher | `read`, `search` e `web` so quando necessario | achados, evidencias, opcoes, nivel de confianca |
| executor | `read`, `search`, `edit` | superficie usada, mudancas feitas, validacao, risco residual |
| reviewer | `read`, `search` | findings, severidade, lacunas de teste, risco de regressao |
| auditor | `read`, `search` | overlaps, ownership, anti-padroes, correcoes minimas |
| orchestrator | `read`, `search`, `agent`, `todo` | sequencia de handoffs, ownership, consolidacao e proximo passo |
| operator | envelope minimo verificado no catalogo local | precondicoes, acao executada, evidencias, rollback ou risco residual |

Regras fortes:

- se o agent delega, ele precisa dizer o que pediu e o que recebeu de volta
- se o agent e reviewer ou auditor, evite sair com recomendacoes vagas sem prioridade
- se o agent e executor ou operator, a validacao precisa aparecer na saida