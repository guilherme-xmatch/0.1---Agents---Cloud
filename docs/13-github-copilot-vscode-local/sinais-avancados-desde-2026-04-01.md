# Sinais avancados desde 2026-04-01

Este documento amplia o dossie principal com um recorte mais recente e mais experimental sobre GitHub Copilot local no VS Code.

Objetivo:

- consolidar sinais oficiais recentes que mudam o desenho local no editor
- acrescentar discussoes de forum que nao estavam no corpus original de repositorios e Medium
- acrescentar sites especialistas e analises inovadoras circulando na comunidade desde `2026-04-01`
- traduzir esses sinais em implicacoes concretas para a documentacao e para a skill `copilot-vscode-engenharia-agents`

## 1. Snapshot deste recorte

| Corpus adicional | Contagem usada aqui | Observacao |
| --- | --- | --- |
| sinais oficiais recentes reavaliados | 15 | baseados no snapshot oficial local de 2026-05-19 e em itens oficiais com data clara quando disponivel |
| fontes de forum/discussao | 30 | 17 threads do Hacker News, 10 GitHub Issues e 3 perguntas do Stack Overflow |
| sites especialistas e analises | 20 | 5 com data de pagina verificavel e 15 ancorados pela data verificavel da thread publica que os circulou |
| sinais repo-backed de inovacao | 10 | repositórios, plugins, sidecars, skill suites e harnesses citados nas discussoes recentes |

Convencoes de rigor usadas aqui:

- `Verificado`: URL e data observavel pela API, pela pagina ou por URL datada
- `Inferencia`: conclusao arquitetural derivada de varios sinais, sem contrato oficial unico
- `Hipotese`: ideia plausivel, mas ainda fraca demais para virar recomendacao forte

## 2. O que mudou no sinal oficial recente

| Sinal oficial recente | Base principal | Estado | Por que importa para o VS Code local |
| --- | --- | --- | --- |
| `.agent.md` se consolidou como formato-alvo | VS Code Docs `custom-agents.md` | Verificado | enfraquece `chatmodes` como target novo de runtime |
| subagents viraram primitive central de isolamento | VS Code Docs `subagents.md` | Verificado | reforca orquestracao por contexto limpo em vez de agent monolitico |
| planning ganhou peso operacional real | VS Code Docs `planning.md` | Verificado | o desenho local fica mais forte quando plano, pesquisa e execucao sao separados |
| skills continuam sendo capability packs, nao prompts grandes | VS Code Docs `agent-skills.md` | Verificado | nossa biblioteca de skills precisa permanecer enxuta e portavel |
| hooks seguem em `Preview` | VS Code Docs `agent-hooks.md` | Verificado | guardrails valem a pena, mas ainda pedem rollout cuidadoso |
| agent plugins aparecem como superficie emergente | VS Code Docs `agent-plugins.md` | Verificado | o catalogo local pode precisar dialogar com plugins alem de MCP |
| memoria local esta mais explicita em tres escopos | GitHub Docs `copilot-memory.md` | Verificado | reforca que memoria nao substitui policy versionada |
| MCP file-based config ganhou mais peso pratico | VS Code Docs `mcp-configuration.md` e GitHub Docs `set-up-the-github-mcp-server.md` | Verificado | aumenta a necessidade de tratar `.vscode/mcp.json` como envelope de risco real |
| approvals e tool governance ficaram mais visiveis | VS Code Docs `tools.md` e `Chat: Manage Tool Approval` | Verificado | o blast radius do runtime ja nao e so textual, e de aprovacao efetiva |
| monitoramento e observabilidade entraram na conversa | VS Code Docs `monitoring-agents.md` | Verificado | times maduros vao precisar de telemetria e logs de agentes, nao so prompts melhores |

Leitura curta:

1. o desenho local esta mais orientado a runtime e menos a prompt unico
2. o risco real migrou para tool envelope, approvals, MCP e handoffs
3. a documentacao local precisa refletir isso em troubleshooting, governance e desenho de agents

## 3. Fontes de forum e discussao desde 2026-04-01

### 3.1 Hacker News

| # | Data | Discussao | Foco | Classe |
| --- | --- | --- | --- | --- |
| 1 | 2026-05-15 | [The Coding Harness Behind GitHub Copilot in VS Code](https://news.ycombinator.com/item?id=48154250) | harnesses de runtime do Copilot | direto |
| 2 | 2026-05-14 | [Improving token efficiency in GitHub Agentic Workflows](https://news.ycombinator.com/item?id=48136229) | eficiencia de tokens em workflows agenticos | direto |
| 3 | 2026-05-14 | [Show HN: JDS - a Copilot skill suite for structuring AI coding behavior](https://news.ycombinator.com/item?id=48140677) | skill suites e comportamento estruturado | direto |
| 4 | 2026-05-13 | [Show HN: AgentKanban for VS Code - A task board with agent harness integration](https://news.ycombinator.com/item?id=48120260) | kanban e harness de agents | adjacente |
| 5 | 2026-05-12 | [Give coding agents real product context so they stop guessing](https://news.ycombinator.com/item?id=48106987) | product context e MCP | adjacente |
| 6 | 2026-05-06 | [Update on "Co-authored-by: Copilot" in commit messages](https://news.ycombinator.com/item?id=48031707) | governanca de commits e atribuicao | direto |
| 7 | 2026-05-02 | [VS Code inserting 'Co-Authored-by Copilot' into commits regardless of usage](https://news.ycombinator.com/item?id=47989883) | governanca e comportamento inesperado | direto |
| 8 | 2026-04-30 | [Tell HN: VS Code v1.117.0 automatically adds GitHub Copilot as your co author](https://news.ycombinator.com/item?id=47958353) | co-authoring por default | direto |
| 9 | 2026-04-27 | [Show HN: Agent Context - let your AI coding tools see your reference projects](https://news.ycombinator.com/item?id=47919538) | referenciais de contexto e retrieval | adjacente |
| 10 | 2026-04-27 | [Copilot silently inserts itself as a co-author in VS Code](https://news.ycombinator.com/item?id=47922996) | atrito de UX e policy | direto |
| 11 | 2026-04-26 | [Mastermind - agentic SDLC workflow for VS Code](https://news.ycombinator.com/item?id=47913243) | SDLC orientado a agents | adjacente |
| 12 | 2026-04-21 | [GitHub Copilot Pro+ not allowing Claude Opus 4.6](https://news.ycombinator.com/item?id=47844903) | gating de modelos | direto |
| 13 | 2026-04-16 | [GitHub Copilot Chat 0.44.1 - Possible Malicious Release](https://news.ycombinator.com/item?id=47799186) | confianca no canal de release | direto |
| 14 | 2026-04-15 | [Agents hooked into GitHub can steal creds](https://news.ycombinator.com/item?id=47782953) | threat model de agents conectados ao GitHub | adjacente |
| 15 | 2026-04-15 | [Show HN: MCP server gives your agent a budget (save tokens, get smarter results)](https://news.ycombinator.com/item?id=47780622) | orcamento e custo em MCP | adjacente |
| 16 | 2026-04-14 | [Sidecar: Mirror VS Code Copilot Chat to your phone over a WebSocket bridge](https://news.ycombinator.com/item?id=47772742) | sidecar e extensao de chat surfaces | adjacente |
| 17 | 2026-04-14 | [Agent Skills for Software Test Automation](https://news.ycombinator.com/item?id=47765765) | skills especializadas para QA | adjacente |

### 3.2 GitHub Issues

| # | Data | Discussao | Foco | Classe |
| --- | --- | --- | --- | --- |
| 18 | 2026-04-23 | [[Feature Request] Allow subagents to override reasoning effort in CustomAgentConfig](https://github.com/github/copilot-sdk/issues/1131) | override de reasoning effort em subagents | direto |
| 19 | 2026-04-03 | [`runSubagent` tool not available to custom agents invoked as subagents](https://github.com/microsoft/vscode/issues/307547) | nested subagents quebrados | direto |
| 20 | 2026-04-11 | [Copilot CLI subagents not rendered correctly](https://github.com/microsoft/vscode/issues/309217) | UX de subagents no CLI | adjacente |
| 21 | 2026-04-28 | [Support file-based MCP server configuration (mcp.json)](https://github.com/microsoft/copilot-for-eclipse/issues/127) | MCP file-based config | adjacente |
| 22 | 2026-04-26 | [Add support for GitHub Copilot CLI](https://github.com/opentrace/opentrace/issues/363) | integração com Copilot CLI | adjacente |
| 23 | 2026-04-27 | [GitHub Copilot code review instructions](https://github.com/open-telemetry/opentelemetry-specification/issues/5054) | instrucoes de code review | adjacente |
| 24 | 2026-04-24 | [docs(ai): .github/copilot-instructions.md mirroring AGENTS.md](https://github.com/alunduil/network-uri-json/issues/85) | relacao entre instructions e AGENTS.md | direto |
| 25 | 2026-05-11 | [ontology agentic setup review for 2026-05-11](https://github.com/ai4curation/agent-watcher/issues/42) | auditoria periodica de setup agentico | adjacente |
| 26 | 2026-05-18 | [ontology agentic setup review for 2026-05-18](https://github.com/ai4curation/agent-watcher/issues/49) | auditoria periodica de setup agentico | adjacente |
| 27 | 2026-04-03 | [Subagent models are ignored when using GitHub Copilot provider](https://github.com/anomalyco/opencode/issues/20859) | billing e modelo do orchestrator vs subagent | direto |

### 3.3 Stack Overflow

| # | Data | Discussao | Foco | Classe |
| --- | --- | --- | --- | --- |
| 28 | 2026-05-13 | [Are VS Code Copilot Agent Debug Log Token Counts the Exact Billing Metrics?](https://stackoverflow.com/questions/79940318/are-vs-code-copilot-agent-debug-log-token-counts-the-exact-billing-metrics) | billing e observabilidade | direto |
| 29 | 2026-04-24 | [VS Code Copilot Agent/Chat extension cannot see terminal command output](https://stackoverflow.com/questions/79931088/vs-code-copilot-agent-chat-extension-cannot-see-terminal-command-output) | terminal visibility e contexto de execucao | direto |
| 30 | 2026-04-19 | [Boss wants us to add more AI to our workflow](https://stackoverflow.com/questions/79928220/boss-wants-us-to-add-more-ai-to-our-workflow) | adocao pragmatica e resistencia organizacional | adjacente |

## 4. 20 sites especialistas e analises recentes

Observacao metodologica:

- `date basis = page` quando a pagina expunha data verificavel por URL, metadata ou slug
- `date basis = thread` quando a pagina nao expunha data de forma confiavel e a contagem foi ancorada na thread publica recente que a trouxe a tona

| # | Fonte | Date basis | Classe | Por que importa |
| --- | --- | --- | --- | --- |
| 1 | [The Coding Harness Behind GitHub Copilot in VS Code](https://code.visualstudio.com/blogs/2026/05/15/agent-harnesses-github-copilot-vscode) | 2026-05-15 page | direto | explicita harnesses e runtime local como superficie arquitetural |
| 2 | [Improving token efficiency in GitHub Agentic Workflows](https://github.blog/ai-and-ml/github-copilot/improving-token-efficiency-in-github-agentic-workflows/) | 2026-05-07 page | direto | traz custo e token efficiency para o centro do desenho multiagente |
| 3 | [GitHub Copilot - Community-contributed agents, instructions, and skills](https://awesome-copilot.github.com/) | 2026-04-10 thread | direto | evidencia catalogos publicos de assets para Copilot |
| 4 | [StoriesOnBoard MCP server overview](https://docs.storiesonboard.com/en/articles/14625286-storiesonboard-model-context-protocol-mcp-server-overview) | 2026-05-12 page | adjacente | mostra product context como recurso MCP reutilizavel |
| 5 | [AgentKanban for VS Code](https://www.agentkanban.io/) | 2026-05-13 thread | adjacente | junta task board e harness de agents no editor |
| 6 | [Paper Lantern for coding agents](https://www.paperlantern.ai/code) | 2026-04-17 thread | adjacente | retrieval de tecnicas sob demanda para coding agents |
| 7 | [Agents hooked into GitHub can steal creds](https://www.theregister.com/2026/04/15/claude_gemini_copilot_agents_hijacked/) | 2026-04-15 page | adjacente | reforca o threat model de agents conectados a GitHub |
| 8 | [MCP server gives your agent a budget](https://l6e.ai) | 2026-04-15 thread | adjacente | introduz budget-awareness em MCP e tool calling |
| 9 | [Context Engineering for AI Coding Agents](https://amux.io/guides/claude-code-subagents/) | 2026-04-08 page | adjacente | reforca subagents, contexto e especializacao por papel |
| 10 | [skillstui](https://skillstui.sh) | 2026-04-10 thread | adjacente | descoberta e instalacao de skills como camada de UX |
| 11 | [Twill.ai](https://twill.ai) | 2026-04-10 thread | adjacente | delegacao para cloud agents com retorno em PRs |
| 12 | [Relvy](https://www.relvy.ai) | 2026-04-09 thread | adjacente | runbooks e automacoes operacionais como assets para agents |
| 13 | [APIMatic context plugins showcase](https://www.apimatic.io/product/context-plugins/showcase) | 2026-04-09 thread | adjacente | mostra plugins/context packs para integracao com APIs |
| 14 | [DataFrey MCP docs](https://docs.datafrey.ai) | 2026-04-21 thread | adjacente | padrao de MCP verticalizado por dominio |
| 15 | [Recursive-Mode](https://recursive-mode.dev/introduction) | 2026-04-11 thread | adjacente | workflows recursivos para coding agents |
| 16 | [Context engineering limits](https://stephenfritz.dev/blog/context-engineering/) | 2026-04-23 thread | adjacente | critica a fragilidade de agents sem contexto disciplinado |
| 17 | [SimplePDF Copilot tool-calling demo](https://copilot.simplepdf.com/?share=a7d00ad073c75a75d493228e6ff7b11eb3f2d945b6175913e87898ec96ca8076&form=w9&lang=en) | 2026-05-02 thread | adjacente | tool calling no cliente com UX mais controlada |
| 18 | [The Daily Claude / Trawl CLI](https://the-daily-claude.github.io/the-daily-claude/) | 2026-04-20 thread | adjacente | observabilidade de harness e logs de agents |
| 19 | [LoxeAI](https://loxeai.com) | 2026-05-17 thread | adjacente | governanca e readiness de seguranca para agentic tooling |
| 20 | [Eve / Managed OpenClaw](https://eve.new/login) | 2026-04-10 thread | adjacente | ambiente gerenciado para agents em contexto de trabalho |

## 5. 10 sinais inovadores da comunidade e de repositorios

| Sinal | Evidencia principal | Estado | Implicacao para nosso setup |
| --- | --- | --- | --- |
| agent harness esta virando conceito operacional explicito | VS Code blog, AgentKanban, Sidecar | Verificado | documentacao local precisa tratar harness, logs e UX do agente como parte do desenho |
| suites de skills e catalogs publicos estao crescendo | JDS, awesome-copilot, skillstui | Verificado | vale fortalecer discoverability e governanca do nosso catalogo |
| product context persistente virou diferencial competitivo | StoriesOnBoard MCP, draft-cli-plugin, Agent Context | Verificado | skill de agents deve pensar mais em contexto e menos em prompt longo |
| MCP com budget e contexto vertical cresce mais rapido que MCP generico | l6e.ai, DataFrey, APIMatic | Verificado | o padrao novo e MCP estreito e orientado a custo/resultado |
| observabilidade de agents deixou de ser detalhe | LazyAgent, Trawl CLI, OpenTelemetry issue | Inferencia forte | nosso dossie deve falar mais de logs, telemetria e troubleshooting |
| seguranca de agents conectados ao GitHub virou tema central | The Register, pre-tool guards, issue discussions | Verificado | approvals, blast radius e hooks merecem mais destaque nos guias |
| nested subagents ainda tem rugosidade real | `runSubagent` bug, reasoning override issue, billing mismatch issue | Verificado | a documentacao deve evitar vender subagents como surface totalmente lisa |
| file-based MCP config virou expectativa cross-client | issue do Copilot for Eclipse e repos com `.vscode/mcp.json` | Verificado | o valor do `mcp.json` compartilhado esta subindo em varios clientes |
| atribuicao de commits pelo Copilot entrou no radar de governanca | threads e issues sobre `Co-authored-by` | Verificado | vale documentar policy explicita de commit attribution |
| workflows recursivos, kanban e SDLC agentico estao saindo do papel | Recursive-Mode, Mastermind, InsForge | Inferencia forte | nosso playbook pode tratar fleet e ownership como camada de processo, nao so de arquivos |

## 6. O que vale adicionar a nossa skill de engenharia de agents

Recorte especifico para [copilot-vscode-engenharia-agents](../../.github/skills/copilot-vscode-engenharia-agents/README.md):

1. incluir um reference curto sobre limites reais de subagents: nested `runSubagent`, override de reasoning effort e billing por orchestrator
2. expandir o checklist de orchestrators para incluir custo, approvals e contrato de retorno mais estrito
3. adicionar um warning sobre `Co-authored-by` e atribuicao automatica quando o workflow tocar git e commits
4. reforcar nos templates a diferenca entre `context source`, `tool surface` e `memory`
5. acrescentar uma nota de observabilidade: logs, harnesses e sinais de UX importam tanto quanto o frontmatter
6. quando um agent depender de MCP, explicitar se o setup presume `mcp.json` compartilhado ou config pessoal

## 7. Conclusao operacional

O ganho principal desta ampliacao nao esta em mudar o contrato basico do Copilot local. O ganho esta em atualizar o dossie para o que a comunidade realmente esta discutindo agora:

- subagents com custo, billing e nested invocation ainda instaveis
- agent harnesses, observabilidade e sidecars aparecendo como nova camada de runtime
- product context e MCP verticalizados ganhando mais valor que integracoes genericas
- governanca de commits, approvals e seguranca entrando no centro das discussoes

Isso sugere um proximo passo claro para o repositorio: manter o dossie principal como base estrutural e usar este recorte avancado para puxar evolucoes incrementais em troubleshooting, observabilidade, governanca e desenho de agents especializados.