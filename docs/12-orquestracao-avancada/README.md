# Orquestração avançada de agentes no Claude Code

Este capítulo aprofunda um recorte específico: como orquestrar trabalho agentic avançado no Claude Code e no ecossistema Anthropic, com foco em coordenação controlada por script, delegação multiagente, workflows em background, validação, fallback e execução híbrida entre ambiente local e cloud.

Ele responde a duas perguntas centrais:

1. até onde dá para construir orquestradores controlados por scripts sobre o Claude Code
2. quais abordagens avançadas, recentes e arquiteturalmente mais profundas aparecem no produto e no ecossistema a partir de 2026-04-01

Leituras complementares:

- [Arquitetura central](../01-arquitetura-central/README.md)
- [MCP e ecossistema de ferramentas](../03-mcp/README.md)
- [Subagents](../05-subagents/README.md)
- [Hooks](../06-hooks/README.md)
- [Skills, plugins e extensibilidade](../07-skills-e-plugins/README.md)
- [Performance, custo e confiabilidade](../08-performance-custo/README.md)
- [Insights, lacunas e mapa de fontes](../10-insights-e-fontes/README.md)
- [Análise externa e configurações comunitárias](../11-analise-externa-e-configs-comunitarias/README.md)
- [Exemplo de coordenador](./orchestrator-coordinator.example.md)

## 1. Base de evidências usada neste capítulo

### Corpus oficial

[Oficial] Este capítulo foi construído a partir do corpus oficial já consolidado nesta pesquisa, com 93 páginas documentais lidas ou indexadas no snapshot de maio de 2026.

Para este recorte, as páginas mais estruturantes foram:

- `how-claude-code-works`
- `sub-agents`
- `hooks` e `hooks-guide`
- `skills`
- `mcp`
- `tools-reference`
- `agent-sdk/overview`, `agent-sdk/agent-loop`, `agent-sdk/subagents`, `agent-sdk/claude-code-features`
- `scheduled-tasks`
- `routines`
- `agent-view`
- `agent-teams`
- `agents`
- `remote-control`
- `channels`
- `worktrees`
- `goal`
- weekly digests `2026-w14` até `2026-w19`

### Corpus comunitário

[Corroborado] A camada comunitária usada aqui se apoia no dataset já coletado nesta pesquisa:

- 84 posts do Medium verificados com data maior ou igual a 2026-04-01
- 17 posts com foco direto em Claude Code
- 67 posts adjacentes sobre Anthropic, MCP, agent engineering e workflows agentic
- múltiplos repositórios públicos com `.claude/`, hooks, skills, subagents, plugins e settings verificados por API pública do GitHub

### Convenção de evidência

- `Oficial`: explicitamente documentado
- `Corroborado`: confirmado por múltiplas fontes técnicas confiáveis
- `Emergente`: padrão recorrente da comunidade, não contrato nativo do produto
- `Inferência arquitetural`: conclusão plausível baseada no comportamento documentado
- `Lacuna`: comportamento não fechado pelo material oficial

## 2. Mapa de superfícies de orquestração

Antes de discutir padrões, vale separar as superfícies reais de coordenação disponíveis.

| Superfície | Papel arquitetural | Nativo? | Melhor uso |
| --- | --- | --- | --- |
| `claude -p` | execução headless/session-driven por script | oficial | automação local, CI leve, wrappers shell/PowerShell |
| Agent SDK | loop agentic programável | oficial | orquestradores externos, apps, pipelines e UIs próprias |
| Subagents | delegação interna com contexto isolado | oficial | pesquisa lateral, fan-out controlado, resumo de alto sinal |
| Hooks | interceptação determinística do lifecycle | oficial | enforcement, auditoria, validação, gateways de decisão |
| Skills | conhecimento e workflow reutilizável | oficial | playbooks, bootstrap contextual, composição com subagents |
| MCP | protocolo de ferramentas e recursos externos | oficial | integração com browsers, APIs, bancos, catálogos e sistemas internos |
| Scheduled tasks (`/loop`, cron tools) | repetição session-scoped | oficial | polling rápido, babysitting local, follow-up curto |
| `/goal` | autonomia condicionada a objetivo por turno | oficial | trabalho longo com critério verificável dentro da sessão |
| Agent view (`claude agents`) | supervisão de sessões em background | oficial, preview | malha de sessões independentes gerenciada pelo humano |
| Agent teams | coordenação distribuída com lead e teammates | oficial, experimental | colaboração entre workers, debate e task list compartilhada |
| Worktrees | isolamento de filesystem | oficial | paralelismo seguro, refactors concorrentes, branch swarms |
| Routines | agentes cloud persistentes com triggers | oficial, preview | automação programada, API triggers, GitHub events |
| Channels | event injection em sessão aberta | oficial, preview | CI/chat/alertas entrando em uma sessão já viva |
| Remote Control | superfície remota humana sobre sessão local | oficial, preview | human-in-the-loop assíncrono e mobilidade |
| GitHub Actions | orquestração via runners/CI | oficial | automação repo-centric e workflows disparados por comentários, cron ou PR |

Leitura arquitetural: Claude Code já não é só um agente. Ele virou um conjunto de superfícies de coordenação que podem ser combinadas em vários níveis de autonomia e isolamento.

## 3. Orquestradores controlados por scripts

## 3.1 Resposta curta

Sim, é possível construir ou operar orquestradores controlados por scripts usando Claude Code.

Mas isso precisa ser lido em camadas:

- parte da orquestração é oficialmente suportada e estável
- parte é oficialmente disponível, porém em preview ou experimental
- parte é padrão emergente da comunidade
- parte é só inferência arquitetural plausível, sem contrato explícito do produto

## 3.2 O que é oficialmente suportado

### `claude -p` e a CLI headless

[Oficial] `claude -p` é a forma mais direta de colocar Claude Code dentro de scripts locais. Ele permite:

- rodar consultas não interativas
- continuar ou retomar sessões (`-c`, `-r`)
- usar `--max-turns`, `--max-budget-usd`, `--settings`, `--mcp-config`, `--agents`, `--allowedTools`, `--disallowedTools`, `--output-format`, `--include-hook-events`, `--include-partial-messages`
- operar workflows reproduzíveis em shell, PowerShell, CI e wrappers próprios

Isso já é suficiente para uma classe inteira de orquestradores externos baseados em script.

### Agent SDK como núcleo programável

[Oficial] O Agent SDK expõe o mesmo loop agentic do Claude Code, com controle programático de:

- tools
- permissions
- hooks programáticos
- MCP
- subagents
- budgets
- effort
- sessões e resume/fork

Em termos de arquitetura, o SDK é a superfície oficial mais forte para um orquestrador externo de verdade.

### Hooks como micro-orquestração determinística

[Oficial] Hooks permitem acoplar shell commands, endpoints HTTP, MCP tools, prompts e agent hooks a pontos específicos do lifecycle.

Isso os torna adequados para:

- bloquear ou redirecionar ações
- chamar validadores externos
- acionar scripts de setup e manutenção
- auditar tool use
- transformar o Claude Code em parte de um pipeline maior controlado por policy

O ponto mais forte aqui é que hooks não dependem da vontade do modelo para disparar.

### Skills, subagents e MCP como orquestração interna declarativa

[Oficial] Skills, subagents e MCP não são scripts externos, mas permitem desenhar coreografias internas sofisticadas:

- skills organizam conhecimento e playbooks
- subagents isolam trabalho e paralelizam subtarefas
- MCP injeta novas ferramentas e recursos remotos

Quando combinados, esses mecanismos já formam uma camada nativa de orquestração intra-sessão.

### Scheduled tasks, `/goal`, Routines e GitHub Actions

[Oficial] Existem quatro superfícies oficiais que materializam automação mais explícita:

- `/loop` e cron tools: repetição session-scoped
- `/goal`: continuidade turn-by-turn até condição satisfeita
- Routines: agentes cloud persistentes com schedule, API e GitHub triggers
- GitHub Actions: execução repo-centric via runners e `claude-code-action`

Essas superfícies cobrem boa parte do espectro “script + agenda + gatilho + autonomia”.

## 3.3 O que é padrão emergente da comunidade

[Corroborado] A comunidade já mostra alguns padrões recorrentes, mas eles não devem ser tratados como contrato do produto.

Padrões mais visíveis:

- wrappers shell e PowerShell chamando `claude -p` com prompts, `--settings`, `--agents` e parsing de saída JSON
- repositórios empacotando `.claude/` como kit operacional com agents, hooks, skills e settings
- agentes coordenadores em Markdown usados como “lead session agent” com `claude --agent`
- distribuição desses kits via plugins ou repositórios-template

Esses padrões são tecnicamente válidos e úteis, mas ainda são convenções operacionais, não primitives dedicadas do produto.

## 3.4 O que é inferência arquitetural plausível, mas não nativo

[Inferência arquitetural] Há arquiteturas que fazem muito sentido sobre Claude Code, mas não aparecem como feature nativa fechada:

- orquestrador externo com DAG explícito de tarefas, estados e retries, usando Agent SDK por baixo
- broker/event bus próprio que despacha prompts, consome outputs e retoma sessões por ID
- coordenador externo que usa vários `claude -p` ou várias instâncias do SDK como fleet manager
- pipeline de validação cruzada multi-stage montado fora do produto, com um agente por etapa e policy engine externa

Nada disso contradiz o produto. Apenas não é o modelo nativo “empacotado” do Claude Code.

## 3.5 Quando usar scripts externos versus mecanismos nativos

| Situação | Melhor escolha | Razão |
| --- | --- | --- |
| workflow intra-sessão e contexto compartilhado | subagents, hooks, skills, MCP | menor atrito, menos plumbing externo |
| regra determinística e enforcement | hooks | contrato mais forte do que prompt |
| automação leve em shell/PowerShell | `claude -p` | rápido, simples, scriptável |
| app, serviço ou orquestrador robusto | Agent SDK | melhor superfície oficial programável |
| automação cloud persistente | Routines | gatilhos externos e execução desacoplada da máquina local |
| repo automation / PR bots / cron de CI | GitHub Actions | acoplamento natural ao repositório |
| várias sessões independentes supervisionadas por humano | agent view | observabilidade e dispatch simples |
| coordenação entre workers que precisam conversar | agent teams | task list e messaging nativos |

Regra prática:

- use mecanismos nativos quando a coordenação puder viver dentro de uma sessão ou dentro da superfície oficial do produto
- use scripts externos quando você precisar de integração com seu ecossistema operacional, CI, scheduler, broker, policy engine ou workflow engine já existente

## 3.6 Limitações, riscos e trade-offs

### Segurança

[Oficial + inferência] Os maiores riscos em orquestração scriptada são:

- expansão indevida de permissões via `Bash`, `PowerShell` ou `bypassPermissions`
- hooks lentos ou maliciosos bloqueando ou distorcendo o loop
- MCP com blast radius excessivo
- skills com shell inline e side effects pouco governados
- subprocessos herdando credenciais quando `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` não é usado

### Operação

- scripts externos aumentam observabilidade e controle, mas deslocam complexidade para fora do produto
- workflows nativos menores são mais baratos de operar, mas menos explícitos como máquinas de estado
- agent teams e sessões paralelas multiplicam tokens e custos quase linearmente
- hooks, loops, monitor e goal podem criar automações difíceis de depurar se usados juntos sem desenho claro

### Confiabilidade

- preview features como channels, routines, agent view, ultrareview e forked subagents exigem leitura cuidadosa do status de maturidade
- background sessions e background subagents auto-negam prompts, o que muda bastante o comportamento sob falhas de permissão
- orquestração por sessão aberta depende da sessão estar viva; para persistência real, cloud routines ou CI são mais fortes

## 3.7 Dez insights avançados sobre orquestradores controlados por scripts

1. O Agent SDK é a única superfície oficialmente desenhada para um orquestrador externo de verdade; `claude -p` é excelente para wrappers e automação leve, mas o SDK é o caminho mais sólido para state machines, resume, budget e hooks programáticos.
2. Hooks são a fronteira mais forte entre Claude Code e um policy engine externo. Eles transformam o runtime em algo interceptável, auditável e parcialmente governável por código determinístico.
3. Um coordenador rodando com `claude --agent <name>` é uma forma nativa e pouco óbvia de transformar Claude Code em um “lead agent” configurável, especialmente quando combinado com `Agent(worker-a, worker-b)` no campo `tools`.
4. `mcpServers` inline em subagents são uma forma de orquestração por escopo, não só de integração. Eles reduzem contexto, blast radius e acoplamento do orquestrador principal.
5. `/goal` é a primitive mais próxima de um mini-orquestrador intra-sessão orientado a condição. Ele remove o loop manual por turno sem exigir um scheduler externo.
6. `Monitor` substitui polling cego por observabilidade reativa. Em orquestração avançada, isso reduz latência de reação e custo de tokens quando comparado a loops repetidos de `Bash` ou `/loop` fixo.
7. Channels aproximam Claude Code de uma arquitetura event-driven: o evento entra na sessão viva em vez de disparar uma nova. Isso muda radicalmente o desenho de reação em tempo real, mas ainda é preview e provider-bound.
8. Routines representam a camada oficial de “agente como job remoto”, enquanto GitHub Actions representam “agente como step de pipeline”. Ambos são fortes, mas servem envelopes operacionais muito diferentes.
9. O padrão comunitário de empacotar `.claude/` inteiro como kit operacional é um sinal de maturidade emergente: a comunidade está tratando Claude Code como plataforma local configurável, não só como CLI com prompts.
10. O erro mais comum é tentar resolver tudo com scripts externos cedo demais. Em muitos casos, subagents + hooks + MCP + skills resolvem o problema com menos moving parts e com melhor alinhamento ao runtime nativo.

## 4. Abordagens avançadas após 2026-04-01

## 4.1 Mudanças relevantes no produto e por que importam

| Período / evidência | Capacidade | Relevância para orquestração |
| --- | --- | --- |
| Week 14 | computer use no CLI | amplia o espaço de verificação e automação para apps sem API |
| Week 14 | `PermissionDenied` hook + `defer` em `PreToolUse` | aproxima Claude Code de UIs e orquestradores externos com human-in-the-loop diferido |
| Week 15 | `Monitor` | viabiliza observabilidade reativa sem sleep loop |
| Week 15 | `ultraplan` | separa planejamento forte em cloud da execução local ou remota |
| Week 15 | `/agents` com Running tab melhorado | fortalece governança de workers em uma sessão |
| Week 16 | Routines | adiciona automação cloud trigger-driven oficial |
| Week 16/17 | `ultrareview` | formaliza review paralelo/adversarial em cloud |
| Week 16 | plugin `monitors` | empacota observabilidade contínua como extensão distribuível |
| Week 17 | forked subagents | reduz overhead de contexto em side tasks com mesmo histórico |
| Week 17 | hooks podem chamar MCP tools diretamente | encurta o caminho entre enforcement e integrações remotas |
| Week 18 | `claude ultrareview` non-interactive | leva review swarm para CI e scripts |
| Week 18 | MCP auto-retry em startup | melhora resiliência de ecossistemas de ferramentas |
| Week 19 | `worktree.baseRef` | dá controle fino do baseline de worktrees em paralelismo |
| Week 19 | `autoMode.hard_deny` | endurece autonomia com regras não contornáveis no auto mode |
| Current docs, v2.1.139+ | `/goal` | adiciona loop condition-driven sem scheduler externo |
| Current docs, v2.1.139+ | agent view | adiciona supervisor humano de várias sessões background |

## 4.2 Padrões avançados que emergem desse conjunto

### Workflow linear

[Oficial + tradicional] Um único agente ou sessão executa sequência contínua de análise, edição, validação e síntese.

Melhor uso:

- tarefas pequenas ou fortemente acopladas
- baixo overhead de coordenação

Trade-off:

- contexto cresce rápido
- pouca paralelização real

### Árvore de delegação

[Oficial] A thread principal ou um lead session agent delega subtarefas isoladas a subagents e sintetiza o retorno.

Melhor uso:

- investigação paralelizável
- tarefas onde o pai só precisa de resumos

Trade-off:

- workers não conversam entre si
- síntese volta para o pai e consome contexto

### Fan-out com síntese do pai

[Oficial + corroborado] Disparo de múltiplos subagents para áreas independentes, seguido de síntese central.

Melhor uso:

- auth, DB, API, infra em paralelo
- triagem de causa-raiz com hipóteses independentes

Trade-off:

- resultados volumosos demais anulam parte do ganho de isolamento

### Map-reduce agentic

[Inferência arquitetural plausível] O “map” é realizado por vários workers ou sessões; o “reduce” por um agente líder ou por etapa final em script/SDK.

Melhor uso:

- análises de muitos arquivos, PRs, módulos ou resultados de teste

Implementação prática mais próxima no Claude Code:

- subagents ou sessions background para map
- lead agent, SDK app ou CI step para reduce

### Review cruzado e validação cruzada

[Corroborado + oficial em parte] O padrão aparece comunitariamente e ganha suporte mais forte com `ultrareview`, que adiciona análise paralela e passe adversarial em cloud.

Melhor uso:

- mudanças de alto risco
- auth, billing, migrations, data integrity, security-sensitive code

### Coordenação por lead agent

[Oficial + inferência] O líder pode ser:

- a thread principal com subagents
- um agent configurado com `--agent`
- o team lead em agent teams
- um processo SDK externo

Esse é o padrão mais forte para workflows avançados: um componente decide, workers exploram, validam ou executam, e a síntese volta para o centro.

### Background swarm supervisionado por humano

[Oficial, preview] Agent view formaliza uma malha de sessões em background supervisionadas por humano. Não é um multi-agent mesh conversacional, mas é uma forma poderosa de orquestração paralela operacional.

### Cloud plan, local execute

[Oficial, preview] `ultraplan` cria um padrão híbrido novo: planejamento mais pesado e revisável na web, execução local ou cloud depois.

### Event-driven orchestration

[Oficial, preview] Channels e Routines aproximam o Claude Code de uma arquitetura baseada em eventos. Um fluxo pode ser empurrado por webhook, chat, CI, GitHub event ou API trigger, em vez de nascer só de uma sessão humana.

### Worktree swarms

[Oficial + corroborado] Worktrees, `isolation: worktree`, `worktree.baseRef` e `/batch` apontam para um padrão de swarm de mudanças isoladas, especialmente útil em migrações mecânicas e refactors amplos.

## 4.3 Comparação prática entre padrões

| Padrão | Melhor primitive | Vantagem | Limitação |
| --- | --- | --- | --- |
| linear | sessão única | simplicidade | contexto e latência |
| árvore | subagents | isolamento barato | sem comunicação lateral |
| fan-out | subagents / agent view | paralelismo direto | síntese pode ficar cara |
| map-reduce | subagents + lead / SDK | escala melhor em análises amplas | exige síntese disciplinada |
| review cruzado | ultrareview / agent teams / lead+workers | maior chance de achar defeitos sutis | custo alto |
| validação cruzada | hooks + subagents + monitor | mistura julgamento e enforcement | desenho mais complexo |
| coordenação por lead | `--agent`, teams, SDK | separa controle de execução | aumenta necessidade de design explícito |
| event-driven | channels / routines / GitHub Actions | reage a mundo externo | disponibilidade e maturidade variam |

## 4.4 Dez insights avançados sobre abordagens recentes e profundas

1. O produto está migrando de “um agente com tools” para “uma malha de execução” com múltiplos envelopes: sessão local, subagent, sessão background, teammate, routine cloud e canal de evento.
2. `Monitor` muda o desenho de autonomia porque reduz a necessidade de polling. Isso torna workflows agentic mais responsivos e menos desperdiçadores de contexto.
3. `ultraplan` inaugura um padrão híbrido importante: planejar em cloud com interface rica e executar onde o ambiente faz mais sentido. É um passo para separar raciocínio caro de execução contextual.
4. `ultrareview` mostra uma direção clara: validação de alto risco tende a convergir para paralelismo especializado com passe adversarial, não para um único agente linear mais “inteligente”.
5. Forked subagents reduzem o custo de side tasks que precisam do mesmo histórico, mas trocam isolamento por conveniência. Isso é ótimo para exploração paralela do mesmo problema e ruim para tarefas que precisam de contexto limpo.
6. `defer` em hooks e o ecossistema de `stream-json`/SDK tornam plausível plugar Claude Code em UIs próprias de aprovação, o que é fundamental para ambientes corporativos com human-in-the-loop explícito.
7. `autoMode.hard_deny` é importante porque sinaliza uma evolução de autonomia governada por política, não só por allowlists. Ele aponta para modelos mais duros de guardrail em produção.
8. Worktrees deixaram de ser apenas conveniência operacional. Com `worktree.baseRef`, `isolation: worktree`, agent view e `/batch`, eles se tornam primitive estratégica de paralelismo seguro.
9. A diferença real entre subagents e agent teams não é “escala”, e sim topologia de comunicação. Esse é o critério arquitetural mais importante para escolher entre eles.
10. O ecossistema recente favorece arquiteturas híbridas: script externo para acionar e governar, Claude Code nativo para executar e sintetizar, hooks para enforcement, MCP para capacidade, e cloud surfaces para trabalhos longos ou event-driven.

## 5. Recomendações arquiteturais acionáveis

### Para times que querem subir um nível sem complexidade excessiva

1. comece com subagents + hooks + worktrees
2. introduza `claude -p` ou Agent SDK só quando precisar de automação externa explícita
3. use `Monitor` antes de inventar loops de polling
4. use `mcpServers` inline em workers especializados para reduzir blast radius

### Para times com plataforma interna forte

1. trate hooks como camada de policy enforcement
2. trate Agent SDK como runtime de integração, não só como biblioteca de demo
3. use GitHub Actions e Routines para envelopes diferentes de automação
4. padronize kits `.claude/` e plugins internos para distribuição consistente

### Para ambientes de alto risco

1. prefira review cruzado, validação cruzada e gates determinísticos
2. use `autoMode.hard_deny`, deny rules, sandbox e `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`
3. considere `bypassPermissions` apenas em ambientes realmente isolados
4. trate preview features como aceleradores experimentais, não como base estável de controle

## 6. Lacunas e limites desta análise

- a literatura comunitária direta sobre Claude Code ainda é menor do que a literatura oficial e a literatura adjacente sobre MCP e agent engineering
- parte das técnicas mais profundas observadas hoje ainda depende de compor superfícies diferentes, não de uma primitive única de “workflow engine” embutida
- alguns recursos que mais mudam o desenho de orquestração continuam em preview ou experimental, especialmente agent view, routines, channels, forked subagents, ultraplan e ultrareview
- há limites documentais ainda abertos sobre heurísticas internas de roteamento, sumarização e triggering automático

## 7. Fechamento

O ponto principal desta análise é simples:

- sim, Claude Code já suporta orquestração controlada por scripts em grau relevante e tecnicamente sério
- o caminho mais oficial para isso é `claude -p` e, principalmente, o Agent SDK
- o caminho mais forte dentro do runtime nativo é combinar subagents, hooks, skills, MCP, worktrees e superfícies recentes como `Monitor`, `/goal`, agent view e routines
- os padrões mais avançados pós-2026-04-01 apontam para arquiteturas híbridas, com liderança explícita, paralelismo seletivo, validação cruzada e mais ênfase em governança do que em “um agente único cada vez mais esperto”

Para materializar esse desenho em algo configurável, veja [Exemplo de coordenador](./orchestrator-coordinator.example.md).