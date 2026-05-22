# Handoffs no GitHub Copilot local do VS Code: leitura avancada desde 2026-04-01

Este documento aprofunda um ponto especifico que ficou distribuido entre o dossie principal, a fleet local e a skill de orquestracao: **handoffs entre agents e subagents**.

Ele nao reinicia a pesquisa. Ele reorganiza o corpus ja auditado neste repositorio em torno de uma pergunta pratica:

> como handoffs realmente bons estao sendo desenhados, onde a comunidade esta inovando, onde o runtime ainda e rugoso e o que isso muda para a nossa documentacao e para a skill de orquestracao?

## 1. Base de evidencia usada aqui

Este recorte herda a base auditada desta sessao e filtra apenas o que e relevante para handoffs:

| Base | Contagem reutilizada | Onde auditar |
| --- | --- | --- |
| Documentacao oficial utilizavel | 270 fontes | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Medium com data verificavel `>= 2026-04-01` | 75 posts | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Padroes comunitarios detalhados | 60 | [Padroes comunitarios](./padroes-comunitarios.md) |
| Artefatos `repo/path` visiveis nas consultas consolidadas | pelo menos 230 | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Forums e discussoes `>= 2026-04-01` | 30 fontes | [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) |
| Sites especialistas e analises recentes | 20 fontes | [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) |

Leitura de rigor:

- este documento **reusa** a cota ja atingida de 30 discussoes e 20 sites, mas destaca apenas o subconjunto que realmente afeta handoffs
- quando o oficial conflita com a comunidade, o oficial vence
- onde a comunidade mostra algo que o oficial ainda nao fecha totalmente, o texto marca como `Inferencia` ou como limite aberto

## 2. O que ja estava forte no repositorio sobre handoffs

O repositorio ja tinha uma base boa antes desta ampliacao.

Camadas fortes ja existentes:

1. [Fleet de agents e handoffs](./fleet-de-agents-e-handoffs.md) ja define:
   - pivot de delegacao
   - envelopes de tools por papel
   - grafo de handoffs recomendado
   - contratos de saida por papel
2. A skill [copilot-vscode-orquestracao-subagents](../../.github/skills/copilot-vscode-orquestracao-subagents/SKILL.md) ja define:
   - quando usar subagents
   - fato verificado sobre `runSubagent`
   - fluxo plan-first
   - limites de paralelismo
3. O [Playbook operacional](./playbook-operacional.md) ja explicava:
   - planner -> researcher -> implementer -> reviewer
   - blast radius menor para planner e reviewer
   - ownership antes da edicao

O que ainda estava mais fraco:

| Ponto | Lacuna principal |
| --- | --- |
| concretude do handoff | pouca exemplificacao de output bom vs ruim |
| runtime real | nested subagents, billing e override de reasoning ainda apareciam pouco |
| observabilidade | logs, harness e rastreabilidade de handoff estavam subrepresentados |
| governanca de fluxo | approvals, custo e atribuicao de commits ainda nao apareciam com peso suficiente |

## 3. O que o oficial e o corpus de alta confianca realmente fecham sobre handoffs

| Sinal | Estado | Implicacao pratica |
| --- | --- | --- |
| subagents sao a primitive nativa de isolamento de contexto | Verificado | handoff bom reduz ruido e devolve apenas sintese util |
| `runSubagent` e a tool primaria de delegacao | Verificado | o agente principal precisa expor a tool correta para orquestrar |
| custom agents podem rodar como workers em subagents | Verificado | papel persistente + contexto isolado e o padrao nativo forte |
| nested subagents exigem setting especifico | Verificado | delegacao recursiva nao deve ser assumida como default |
| o Plan agent persiste `plan.md` em memoria de sessao | Verificado | handoff maduro pode referenciar plano persistido, nao so contexto ephemero |
| approvals e tool governance definem o blast radius real | Verificado | o custo e o risco do handoff dependem das ferramentas realmente liberadas |
| subagents nao devem disputar os mesmos arquivos sem ownership | Verificado / Inferencia forte | paralelismo sem ownership claro vira anti-padrao |
| `implementer` continua sendo pattern, nao primitive oficial separada | Inferencia forte | a documentacao deve vender handoff para implementer como pattern do time |

Leitura operacional:

- handoff nao e apenas “passar contexto”
- handoff e desenhar **quem faz o que**, **com quais tools**, **com qual output**, **com qual risco** e **com qual criterio de parada**

## 4. O que os repositorios mostram na pratica

Os sinais abaixo ja estavam observados em [Padroes comunitarios](./padroes-comunitarios.md), mas aqui sao reorganizados para a lente de handoffs.

| Sinal repo-backed | Evidencia observada | O que isso ensina para handoffs |
| --- | --- | --- |
| planner agent em `.agent.md` | `klintravis/CopilotCustomizer` · `.github/agents/Planner.agent.md` | planejamento ja e tratado como papel persistente e separado |
| agent designer interativo | `github/gh-aw` · `.github/agents/interactive-agent-designer.agent.md` | o proprio desenho de novos specialists pode entrar em um fluxo com handoff para builder |
| asset architect agent | `canonical/copilot-collections` · `.github/agents/copilot-asset-architect.agent.md` | arquitetura de assets e materializacao nao precisam ser o mesmo papel |
| evaluation agent | `aalmada/BookStore` · `.github/agents/SquadEval.agent.md` | review/avaliação como worker separado continua sendo padrao forte |
| repo liaison agent | `jlcatonjr/Learn-Python-for-Stats-and-Econ` · `.github/agents/repo-liaison.agent.md` | discovery e onboarding do repo podem ser um handoff intermediario legitimo |
| `_TEMPLATE.agent.md` versionado | `joint-hubs/jointhubs-os` · `.github/agents/_TEMPLATE.agent.md` | catalogos maduros padronizam o shape minimo do worker antes de expandir a fleet |
| pre-tool guard | `foxminchan/BookWorm` · `.github/hooks/scripts/powershell/pre-tool-guard.ps1` | handoff sem guardrail de tool e mais fragil do que parece |
| `mcp.json` compartilhado | `mend-detection-qa/payload` · `.vscode/mcp.json` | workers que usam MCP precisam de governanca compartilhada ou opt-in bem claro |
| `mcp.json.sample` / `.template` | exemplos observados em `northwestern-fy26-msai-foundry-agentic-ai` e `mcp-lawfirm-demo` | handoff com integracao externa madura evita ativacao automatica cega |
| skill builder com validador | `briancl2/CustomerNewsletter` · `validate_skill.py` | o proprio catalogo multiagente pode ser endurecido com automacao leve |

Convergencias praticas mais fortes:

1. planner continua sendo o pivot natural de primeira decomposicao
2. orchestrator coordena e consolida; nao deve competir com workers
3. reviewer e auditor voltam melhor quando o implementer devolve mudanca + validacao, nao dump inteiro
4. ownership de arquivo precede paralelismo real
5. templates e catalogs importam porque handoff ruim quase sempre nasce de papéis mal definidos

## 5. Os sinais mais inovadores da comunidade desde 2026-04-01

Este recorte parte das 30 discussoes e 20 sites ja consolidados em [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md), mas destaca o que muda o desenho de handoffs.

| Sinal inovador | Tipo de sinal | O que muda para handoffs |
| --- | --- | --- |
| agent harness como camada explicita | forum + site especialista | handoff deixa rastros de UX, logs e runtime; nao basta frontmatter |
| observabilidade e billing | Stack Overflow + ferramentas de harness | custo do workflow multiagente passa a fazer parte do desenho |
| nested subagents ainda rugosos | issues recentes | handoff profundo precisa ser tratado como caso de risco, nao default |
| budget-aware MCP | sites e discussoes recentes | delegacao para workers com tools externas precisa olhar custo, nao so completude |
| product context persistente | MCP verticalizado e tools de contexto | o melhor handoff frequentemente reduz reexplicacao porque o worker le contexto certo |
| governanca de `Co-authored-by: Copilot` | 5 threads recentes | workflows que chegam em git e commits precisam policy explicita de atribuicao |
| SDLC agentico, kanban e workflows recursivos | HN + ferramentas experimentais | a unidade de desenho deixa de ser um prompt e passa a ser uma cadeia de handoffs |

Leitura curta:

- a comunidade mais inovadora esta tornando handoffs um problema de **sistema**, nao apenas de copywriting
- hoje, handoff bom depende de contexto, custo, approvals, logs e ownership

## 6. Limites, conflitos e riscos abertos

| Tema | Evidencia | Recomendacao documental |
| --- | --- | --- |
| nested `runSubagent` | issue publica de indisponibilidade em subagent | tratar como limite real de runtime |
| override de reasoning effort | necessidade publica ainda nao plenamente fechada | evitar prometer granularidade fina por worker |
| billing do worker | modelo do subagent pode ser ignorado em certos cenarios | checklist de orchestrator deve tratar custo explicitamente |
| `implementer` como primitive | corpus oficial nao fecha primitive autonoma | documentar como pattern do time |
| `AGENTS.md` | util como contexto, insuficiente como runtime surface | usar como complemento, nao como substituto |

## 7. O que vale puxar agora para a nossa documentacao e para a skill

Backlog priorizado, com foco em melhorias pequenas e de alto impacto.

### P1. Prioridade alta

1. **checklist de handoff com validacao explicita do retorno**
   - o orquestrador validou a sintese antes de prosseguir?
   - o worker devolveu output utilizavel ou apenas transcricao de exploracao?
2. **checklist de limites com risco de nested subagents e billing**
   - setting adicional
   - risco de runtime rugoso
   - custo e modelo efetivo
3. **contratos de saida com exemplo curto de output bom vs ruim**
   - especialmente em `planner -> researcher`, `worker -> orchestrator` e `implementer -> reviewer`

### P2. Prioridade media

4. **reference curta de observabilidade de handoffs**
   - logs
   - token counts
   - diferenca entre sucesso aparente e workflow confiavel
5. **warning operacional sobre `Co-authored-by`**
   - quando o fluxo tocar git, a cadeia de handoff precisa considerar atribuicao automatica

### P3. Endurecimento futuro

6. **rubrica leve de custo por workflow**
   - planner/orchestrator com subagents e MCP
7. **validator de contrato minimo de handoff**
   - para bibliotecas maiores de agents e skills

## 8. Planejamento editorial minimo recomendado

Para nao inflar demais a superficie do repositorio, a melhor distribuicao e:

1. manter [Fleet de agents e handoffs](./fleet-de-agents-e-handoffs.md) como mapa da fleet local
2. manter a skill [copilot-vscode-orquestracao-subagents](../../.github/skills/copilot-vscode-orquestracao-subagents/SKILL.md) como camada operacional
3. usar este documento como recorte **aprofundado e recente** sobre handoffs
4. puxar para a skill apenas o que virar regra operacional, checklist ou contrato de saida mais forte

Em outras palavras:

- o dossie continua explicando o sistema
- a fleet continua explicando a topologia local
- este documento explica o que a fronteira recente da comunidade e do runtime muda **especificamente em handoffs**

## 9. Conclusao operacional

O repositorio ja tinha uma base boa sobre handoffs, mas ainda mais conceitual do que operacional.

O ganho desta ampliacao e deixar claro que handoff maduro, hoje, precisa considerar ao mesmo tempo:

- sintese curta e contrato de saida
- ownership antes da edicao
- tool envelope e approvals
- nested subagents como limite, nao como default
- observabilidade, custo e billing
- policy de commit attribution quando o fluxo tocar git

Se essas camadas forem absorvidas pela documentacao e pela skill de orquestracao, o repositorio passa a falar de handoffs de forma mais fiel ao runtime atual e mais util para times que querem operar fleets de agents de verdade.