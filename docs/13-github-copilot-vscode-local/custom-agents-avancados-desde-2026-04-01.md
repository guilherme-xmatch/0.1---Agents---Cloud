# Custom agents no GitHub Copilot local do VS Code: leitura avancada desde 2026-04-01

Este documento nao reabre a pesquisa do zero. Ele consolida, em torno de **custom agents** (`*.agent.md`), o que ja foi materializado neste repositorio e o que os sinais recentes realmente mudam para a nossa documentacao e para a skill [copilot-vscode-engenharia-agents](../../.github/skills/copilot-vscode-engenharia-agents/SKILL.md).

Objetivo deste recorte:

- analisar o que o repositorio ja construiu bem sobre GitHub Copilot local no VS Code
- isolar as lacunas que ainda existiam especificamente em **custom agents**
- cruzar documentacao oficial, corpus de repositorios, forums e sites especialistas a partir de `2026-04-01`
- transformar isso em implicacoes claras para a nossa documentacao e para a skill de engenharia de agents

## 1. Base de evidencia usada aqui

Este recorte herda e reorganiza o corpus ja auditado nesta sessao:

| Base | Contagem reutilizada | Onde auditar |
| --- | --- | --- |
| Documentacao oficial utilizavel | 270 fontes | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Medium com data verificavel `>= 2026-04-01` | 75 posts | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Padroes comunitarios detalhados | 60 | [Padroes comunitarios](./padroes-comunitarios.md) |
| Artefatos `repo/path` visiveis nas consultas consolidadas | pelo menos 230 | [Fontes e metodologia](./fontes-e-metodologia.md) |
| Forums e discussoes `>= 2026-04-01` | 30 fontes | [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) |
| Sites especialistas e analises recentes | 20 fontes | [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) |

Nota metodologica importante:

- para esta passada focada em custom agents, uma tentativa nova de usar GitHub REST code search sem autenticacao retornou `401 Requires authentication`
- por isso, a camada repo-backed abaixo reutiliza o corpus **ja auditado** em [Padroes comunitarios](./padroes-comunitarios.md), em vez de fingir uma nova coleta completa que nao ocorreu
- isso nao reduz a confianca do recorte, porque o repositorio ja possui 60 padroes e pelo menos 230 artefatos observados diretamente na etapa anterior

## 2. O que ja foi construido neste repositorio

Leitura de estado atual, olhando o conjunto do modulo e nao so um arquivo isolado:

| Camada | Onde ja esta forte | Onde ainda estava mais fraca |
| --- | --- | --- |
| Arquitetura local e precedencia | [README do dossie](./README.md), [Topologia de runtime e pastas](./topologia-de-runtime-e-pastas.md) | runtime edge cases de custom agents ainda apareciam de forma dispersa |
| Fleet local de agents | [Fleet de agents e handoffs](./fleet-de-agents-e-handoffs.md), [Catalogo de agents](../../.github/agents/README.md) | faltava um recorte mais explicito sobre limites de orchestrators e nested subagents |
| Skill de engenharia de agents | [README da skill](../../.github/skills/copilot-vscode-engenharia-agents/README.md), templates, checklists e troubleshooting | ainda mais forte em desenho estrutural do que em observabilidade, custo, billing e governanca de commits |
| Benchmark comunitario | [Padroes comunitarios](./padroes-comunitarios.md) | havia sinais de custom agents, mas nao uma consolidacao dedicada a eles |
| Sinais recentes de comunidade | [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) | o recorte recente estava mais amplo; faltava uma leitura aprofundada so para custom agents |

Conclusao curta:

1. o repositorio ja estava forte em **taxonomia**, **topologia** e **boas praticas de desenho**
2. ele ja estava razoavelmente forte em **templates** e **separacao por papel**
3. a principal lacuna restante estava em **custom agents como runtime real**: nested subagents, billing, observabilidade, commit attribution, product context e orchestration cost-aware

## 3. O que o oficial e o corpus de alta confianca realmente fecham sobre custom agents

| Sinal | Estado | Implicacao pratica |
| --- | --- | --- |
| `*.agent.md` em `.github/agents/` e o formato-alvo atual | Verificado | setups novos nao devem investir em `*.chatmode.md` |
| `description` e uma superficie de descoberta critica | Verificado | descricao vaga degrada delegacao e discoverability |
| `tools` controla o envelope de autonomia efetivo | Verificado | tool surface minima e parte central do desenho do agent |
| `model` por agent importa | Verificado | planner, reviewer e orchestrator pedem postura diferente de executor |
| `agents` como whitelist de subagents permitidos exige cuidado | Verificado | se o agent delega, ele precisa de fronteiras explicitas |
| custom agents podem ser usados como workers em subagents | Verificado | papel persistente + contexto isolado e um padrao nativo forte |
| subagents existem para limpeza de contexto, nao para duplicar ownership | Verificado | edicao concorrente sem contrato claro vira anti-padrao |
| approvals e tool governance definem o blast radius real | Verificado | prompt bom nao compensa permissao ampla demais |
| hooks e observabilidade viraram parte do envelope operacional | Verificado / Preview | runtime bom depende de mais do que frontmatter |
| `implementer` continua sendo pattern, nao primitive oficial separada | Inferencia forte | documentacao local deve evitar vender isso como contrato do produto |

Leitura operacional:

- o design de custom agents deixou de ser apenas um problema de frontmatter
- hoje ele e um problema de **papel**, **ferramentas**, **delegacao**, **aprovacoes**, **custo**, **observabilidade** e **ownership de contexto**

## 4. O que os repositorios mostram na pratica

Os sinais abaixo sao repo-backed e ja estavam auditados em [Padroes comunitarios](./padroes-comunitarios.md). O ganho aqui e reuni-los numa leitura unica para custom agents.

| Sinal repo-backed | Evidencia observada | O que isso ensina |
| --- | --- | --- |
| planner agent em formato novo | `klintravis/CopilotCustomizer` · `.github/agents/Planner.agent.md` | planejamento ja migrou com clareza para `.agent.md` |
| agent especializado em criar agents | `github/gh-aw` · `.github/agents/interactive-agent-designer.agent.md` | a propria engenharia de agents virou papel persistente e especializado |
| asset architect agent | `canonical/copilot-collections` · `.github/agents/copilot-asset-architect.agent.md` | catalogos maduros separam arquitetura de materializacao |
| evaluation agent | `aalmada/BookStore` · `.github/agents/SquadEval.agent.md` | review e scoring separados de execucao continuam um padrao forte |
| repo liaison agent | `jlcatonjr/Learn-Python-for-Stats-and-Econ` · `.github/agents/repo-liaison.agent.md` | onboarding e discovery do repo podem ser papeis proprios |
| template versionado de agent | `joint-hubs/jointhubs-os` · `.github/agents/_TEMPLATE.agent.md` | times maduros padronizam shape minimo para novos agents |
| pre-tool guard | `foxminchan/BookWorm` · `.github/hooks/scripts/powershell/pre-tool-guard.ps1` | tool surface nao basta; guardrail deterministico melhora blast radius |
| `mcp.json` versionado | `mend-detection-qa/payload` · `.vscode/mcp.json` | custom agent forte frequentemente depende de MCP governado |
| `mcp.json.sample` ou `.template` | exemplos em `northwestern-fy26-msai-foundry-agentic-ai` e `mcp-lawfirm-demo` | integracoes externas maduras evitam ativacao cega |
| skill builder com validador | `briancl2/CustomerNewsletter` · `validate_skill.py` | bibliotecas maduras comecam a automatizar qualidade do proprio catalogo |

Convergencias praticas mais fortes dessa camada:

1. decomposicao por papel continua sendo o padrao mais estavel
2. template versionado reduz drift e naming ruim
3. orchestrator bom coordena e consolida; nao compete com os workers
4. hooks e MCP aparecem como extensoes do runtime, nao como substitutos do agent
5. AGENTS.md aparece como complemento em parte da comunidade, mas nao como surface oficial suficiente

## 5. Os sinais mais inovadores da comunidade desde 2026-04-01

Este recorte usa as 30 discussoes e 20 sites recentes ja consolidados em [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md), mas reorganiza o que mais importa para custom agents.

| Sinal inovador | Tipo de sinal | Por que importa para custom agents |
| --- | --- | --- |
| agent harness como conceito explicito | forum + site especialista | custom agent bom precisa pensar em logs, UX e runtime harness, nao so em texto |
| skill suites e catalogs publicos | forum + catalogos | mostra que discoverability e curadoria de assets virou problema de produto |
| product context persistente | MCP verticalizado e tools de contexto | agents com contexto certo superam prompts longos e genericamente verbosos |
| budget-aware MCP | sites e discussoes recentes | custo e consumo de tokens passaram a ser parte do desenho multiagente |
| observabilidade e billing | Stack Overflow + ferramentas de harness | logs de token e billing deixaram de ser detalhe de implementacao |
| governanca de `Co-authored-by: Copilot` | 5 threads recentes | agents que tocam git precisam politica explicita de atribuicao |
| nested subagents ainda rugosos | issues recentes | nao vale vender orchestration profunda como superficie totalmente lisa |
| workflows recursivos, kanban e SDLC agentico | HN + ferramentas experimentais | a comunidade esta movendo o foco de prompt isolado para fleets e processos |

Leitura curta:

- a comunidade mais inovadora esta menos interessada em “um agent melhor” e mais interessada em **harness**, **fleet**, **contexto**, **budget**, **telemetria** e **governanca**
- isso nao substitui o oficial; apenas mostra onde a documentacao local precisa ser mais realista e mais operacional

## 6. Limites, conflitos e riscos que a documentacao precisa explicitar

| Tema | O que fechar | Recomendacao documental |
| --- | --- | --- |
| nested `runSubagent` | ha rugosidade real e bugs publicos | documentar como limite de runtime, nao como detalhe menor |
| override de reasoning effort | ainda aparece como necessidade nao plenamente resolvida | evitar prometer granularidade fina por subagent |
| billing de orchestrator vs worker | a conta nem sempre acompanha o modelo declarado do subagent | tratar custo como parte do checklist de orchestrators |
| `chatmode` legado vs `.agent.md` | a comunidade ainda mistura formatos | oficial vence: `*.agent.md` como formato-alvo |
| AGENTS.md | util como complemento, insuficiente como runtime surface | usar como contexto auxiliar, nao como substituto do stack do Copilot |
| GitHub code search publico | sem autenticacao, a API atual limita parte da coleta | preferir o corpus auditado do repo a improvisar novas contagens |

## 7. O que vale puxar agora para a nossa skill de engenharia de agents

Backlog priorizado, com foco no que realmente aumenta maturidade da skill [copilot-vscode-engenharia-agents](../../.github/skills/copilot-vscode-engenharia-agents/SKILL.md):

### P1. Prioridade alta

1. **reference sobre limites reais de subagents**
   - nested `runSubagent`
   - billing por orchestrator
   - override de reasoning effort como limite aberto
2. **checklist mais forte para orchestrators**
   - custo
   - approvals
   - contrato de retorno
   - ownership dos arquivos e do contexto
3. **warning de commit attribution**
   - quando o agent tocar git, a documentacao deve mandar explicitar policy de `Co-authored-by`

### P2. Prioridade media

4. **reference curta de observabilidade e harness**
   - logs
   - sinais de UX
   - diferenca entre sucesso aparente e runtime saudável
5. **templates com linguagem mais explicita sobre contexto**
   - `context source`
   - `tool surface`
   - `memory`
   - `MCP dependency`

### P3. Endurecimento futuro

6. **validator leve para `.agent.md`**
   - naming
   - frontmatter minimo
   - uso coerente de `agent` tool quando `agents` existir
7. **rubrica de custo e blast radius**
   - especialmente para orchestrator, operator e agents que usam MCP ou git

## 8. Planejamento editorial minimo recomendado

Se a meta for melhorar o repositorio sem inflar a superficie documental, o incremento mais util e:

1. manter o dossie principal em [README.md](./README.md) como mapa estrutural do sistema
2. manter [Sinais avancados desde 2026-04-01](./sinais-avancados-desde-2026-04-01.md) como ledger recente de forums e sites
3. usar este documento como **recorte aprofundado de custom agents**
4. puxar para a skill apenas o que realmente virar regra operacional, checklist, template ou troubleshooting

Em outras palavras:

- o dossie explica o sistema
- o ledger recente explica os sinais novos
- este arquivo explica o que esses sinais mudam **especificamente para custom agents**

## 9. Conclusao operacional

O trabalho feito ate aqui ja construiu uma base forte e auditavel. O que faltava nao era mais volume bruto de fonte; era **foco**.

Esse foco mostra que o proximo salto de maturidade para custom agents nao vem de escrever frontmatter mais bonito. Ele vem de documentar melhor:

- limites reais de subagents
- custo e approvals de orchestrators
- governanca de commits e atribuicao
- observabilidade e harness do runtime
- diferenca entre contexto, memoria, MCP e tools

Se a documentacao e a skill absorverem esses pontos, o repositorio deixa de estar apenas bem organizado e passa a ficar **mais realista, mais sustentavel e mais alinhado com a fronteira atual da comunidade**.