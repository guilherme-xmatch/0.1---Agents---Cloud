# Configuração avançada de subagents

Este documento complementa [Subagents](./README.md) com foco específico em configuração. O objetivo aqui é cobrir o conjunto mais completo possível de opções documentadas, seus efeitos reais em runtime, limitações por escopo e as combinações mais avançadas que fazem diferença em produção.

Leitura de evidência usada neste arquivo:

- `Oficial`: explicitamente documentado pela Anthropic
- `Lacuna`: comportamento não fechado por contrato documental completo
- `Inferência arquitetural`: conclusão razoável derivada do comportamento documentado

## 1. Modelo mental correto de configuração

[Oficial] Um subagent não é apenas um arquivo Markdown com frontmatter. A configuração efetiva depende de quatro camadas ao mesmo tempo:

1. onde o subagent foi definido
2. como ele foi invocado
3. quais settings, permission rules e env vars estão ativos na sessão pai
4. se ele está rodando como subagent nomeado, fork ou agente principal da sessão

Isso muda bastante a leitura dos campos. O mesmo arquivo pode se comportar de forma diferente se for:

- spawnado pelo `Agent` tool
- chamado via `@-mention`
- executado como sessão principal com `claude --agent <name>`
- ativado pelo setting `agent`

## 2. Onde subagents podem ser definidos

[Oficial] Há cinco origens principais para definições de subagent.

| Origem | Escopo | Prioridade | Observações importantes |
| --- | --- | --- | --- |
| Managed settings | organização | 1 | ganha de tudo; adequado para padronização corporativa |
| `--agents` | sessão atual | 2 | efêmero; ótimo para automação, testes e bootstrap |
| `.claude/agents/` | projeto | 3 | versão mais útil para times; pode ir para git |
| `~/.claude/agents/` | usuário | 4 | disponível em todos os projetos do usuário |
| `agents/` de plugin | onde o plugin estiver ativo | 5 | bom para distribuição; tem restrições próprias |

Nuances operacionais importantes:

- diretórios `project` e `user` são escaneados recursivamente
- em `project` e `user`, a identidade vem apenas do campo `name`; o subdiretório não entra no identificador
- em plugins, subpastas entram no identificador escopado, por exemplo `my-plugin:review:security`
- se dois arquivos no mesmo escopo declararem o mesmo `name`, um deles é descartado sem aviso
- diretórios adicionados com `--add-dir` dão acesso a arquivos, mas não são escaneados para subagents
- arquivos editados diretamente em disco só entram em vigor após reiniciar a sessão; subagents criados pelo `/agents` entram imediatamente

## 3. Caminhos de execução que mudam o comportamento

### 3.1 Subagent nomeado normal

[Oficial] É o modo padrão. O worker nasce com contexto fresco e recebe apenas:

- seu próprio system prompt
- o prompt enviado pelo pai via Agent tool
- definições de ferramentas disponíveis
- `CLAUDE.md` e memórias carregadas pelo fluxo normal da sessão

Ele não recebe:

- histórico completo da conversa pai
- system prompt do pai
- tool results do pai

### 3.2 Forked subagent

[Oficial, experimental] Com `CLAUDE_CODE_FORK_SUBAGENT=1`, Claude Code pode spawnar forks que herdam o histórico completo da sessão principal.

Isso muda três coisas centrais:

- o fork compartilha o contexto e o prompt cache do pai
- todo spawn passa a rodar em background por padrão
- named subagents continuam existindo, mas a arquitetura de delegação muda porque o `general-purpose` tende a virar fork

Use fork quando o custo de retransmitir contexto para um subagent nomeado seria alto demais. Evite fork quando o principal benefício esperado for isolamento cognitivo máximo.

### 3.3 Sessão principal rodando como agente

[Oficial] `claude --agent <name>` ou o setting `agent` fazem a thread principal assumir o system prompt, restrições de ferramenta e modelo desse agente.

Isso tem implicações avançadas:

- o prompt do subagent substitui o prompt padrão do Claude Code para a thread principal
- `initialPrompt` só faz sentido neste caminho
- `Agent(worker-a, worker-b)` no campo `tools` passa a funcionar como allowlist de spawning
- hooks do frontmatter passam a rodar também neste modo, junto com hooks de `settings.json`

## 4. Matriz completa de campos de configuração

### 4.1 Campos centrais

| Campo | Obrigatório | Valores / forma | Default | Notas avançadas |
| --- | --- | --- | --- | --- |
| `name` | sim | letras minúsculas e hífens | none | o filename não precisa coincidir; hooks recebem este valor como `agent_type` |
| `description` | sim | texto natural de roteamento | none | Claude usa esta descrição para decidir delegação; frases como `use proactively` influenciam muito o matching |
| corpo Markdown | não, mas fortemente recomendado | system prompt do agente | vazio | em arquivos, o corpo substitui o prompt do agente; no `--agents`, o equivalente é `prompt` |
| `tools` | não | allowlist de ferramentas | herda tudo | se omitido, herda todas as tools do pai, inclusive MCP tools disponíveis |
| `disallowedTools` | não | denylist de ferramentas | none | é aplicada antes de resolver `tools`; se um item aparecer nos dois, ele é removido |
| `model` | não | `sonnet`, `opus`, `haiku`, `inherit` ou model ID completo | `inherit` | aceita o mesmo universo do `--model`; para pinagem real, prefira model ID completo |
| `permissionMode` | não | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` | herda envelope efetivo | ignored em plugin subagents |
| `maxTurns` | não | inteiro positivo | sem limite específico do agente | útil para workers caros, exploratórios ou propensos a looping |
| `skills` | não | lista de nomes de skills | none | preloada o conteúdo completo das skills no startup |
| `mcpServers` | não | nomes de servidores existentes ou definições inline | herda MCP do pai se `tools` permitir | ignored em plugin subagents |
| `hooks` | não | mapa de eventos de hook | none | hooks em frontmatter só vivem enquanto o agente estiver ativo |
| `memory` | não | `user`, `project`, `local` | none | habilita diretório persistente e auto-habilita `Read`, `Write` e `Edit` |
| `background` | não | `true` / `false` | `false` | em background, tool calls que exigiriam prompt são auto-negadas |
| `effort` | não | `low`, `medium`, `high`, `xhigh`, `max` | herda da sessão | disponibilidade depende do modelo |
| `isolation` | não | `worktree` | none | cria cópia isolada do repositório para o worker |
| `color` | não | `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` | none | sem efeito funcional; só UI |
| `initialPrompt` | não | texto | none | só tem efeito quando o agente roda como thread principal via `--agent` ou setting `agent` |

### 4.2 Campos com maior impacto arquitetural

#### `description`

[Oficial + inferência] Este campo é mais importante do que parece. Ele é o classificador informal de roteamento. Descrições genéricas como `helper agent` produzem baixa discriminação e levam o orquestrador a usar menos o agente ou a usá-lo em momentos errados.

Boas descrições:

- definem a especialidade
- dizem quando usar
- indicam se a delegação deve ser proativa
- delimitam o tipo de saída esperado

#### `tools` e `disallowedTools`

[Oficial] A ordem lógica é:

1. Claude parte do conjunto herdado ou explícito
2. aplica `disallowedTools`
3. resolve `tools` sobre o conjunto restante

Consequências práticas:

- allowlist é mais segura do que denylist para agentes críticos
- denylist é útil quando você quer preservar flexibilidade do pai e só retirar um pequeno subconjunto
- se `Agent` não estiver disponível, o agente principal não consegue spawnar outros subagents
- `Agent(worker-a, worker-b)` restringe explicitamente quais tipos o agente principal pode spawnar
- `Task(...)` continua funcionando como alias legado em algumas superfícies, mas a forma atual é `Agent(...)`

Importante: subagents não spawnam outros subagents. Portanto, `Agent(...)` só tem efeito real quando o agente roda como sessão principal.

#### `model`

[Oficial] A resolução do modelo para um subagent segue esta ordem:

1. `CLAUDE_CODE_SUBAGENT_MODEL`
2. parâmetro de invocação por chamada, quando existir
3. `model` do subagent
4. modelo da sessão principal

Implicações úteis:

- a variável de ambiente é o override global mais forte para debugging e testes comparativos
- `inherit` é a opção mais estável quando você quer comportamento alinhado ao pai
- pinagem por model ID é melhor que alias quando seu risco é drift de versão

#### `permissionMode`

[Oficial] O campo é útil, mas o envelope do pai ainda domina partes do comportamento.

Precedência relevante:

- se o pai está em `bypassPermissions`, o subagent não consegue endurecer isso
- se o pai está em `acceptEdits`, o subagent também não consegue endurecer isso
- se o pai está em `auto`, o classificador do pai governa os tool calls do subagent e o `permissionMode` do frontmatter é ignorado

Leitura arquitetural: `permissionMode` no subagent ajusta o worker, mas não redefine a política de confiança da sessão.

#### `skills`

[Oficial] `skills` preloada o conteúdo completo da skill no contexto do worker. Isso é muito diferente de apenas deixá-la invocável pela Skill tool.

Nuances importantes:

- skills não listadas continuam invocáveis se a Skill tool estiver disponível
- para impedir skill invocation, retire `Skill` de `tools` ou adicione-a a `disallowedTools`
- skills com `disable-model-invocation: true` não podem ser preloaded
- se uma skill listada estiver ausente ou desabilitada, Claude Code a ignora e registra warning no debug log

#### `mcpServers`

[Oficial] Este é um dos campos mais poderosos e mais subutilizados.

Cada entrada pode ser:

- uma string referenciando um servidor já configurado
- uma definição inline completa usando o mesmo schema de `.mcp.json`

Diferenças práticas:

- referência por nome reaproveita a conexão da sessão pai
- inline conecta no início do agente e desconecta ao fim
- inline é o melhor caminho para não poluir o contexto principal com descrições de tool que só um worker precisa

Limitação importante: plugin subagents ignoram `mcpServers`.

#### `hooks`

[Oficial] Hooks em frontmatter são hooks scoped ao worker. Eles são ótimos para validação altamente localizada.

Pontos finos:

- todos os eventos de hooks são suportados em frontmatter
- `Stop` em frontmatter é convertido para `SubagentStop` quando o agente roda como subagent
- se o mesmo agente roda como sessão principal via `--agent`, esses hooks rodam junto com hooks definidos em `settings.json`

Limitação importante: plugin subagents ignoram `hooks`.

#### `memory`

[Oficial] `memory` é uma configuração de alto impacto e com efeitos laterais importantes.

Escopos:

- `user`: `~/.claude/agent-memory/<agent>/`
- `project`: `.claude/agent-memory/<agent>/`
- `local`: `.claude/agent-memory-local/<agent>/`

Efeitos automáticos:

- o system prompt passa a instruir leitura e escrita de memória
- as primeiras 200 linhas ou 25 KB de `MEMORY.md` entram no contexto
- `Read`, `Write` e `Edit` são habilitados automaticamente

Esse último ponto é crítico: um agente aparentemente read-only deixa de ser estritamente read-only quando `memory` é ativado.

#### `background`

[Oficial] Um agente em background continua concorrente, mas perde a capacidade prática de parar para pedir ajuda. Tudo que precisaria de prompt é auto-negado.

Use `background: true` quando:

- o worker é bem delimitado
- o envelope de permissões já está aberto
- falha rápida é melhor do que bloquear a sessão principal

Evite quando o fluxo exige interação humana no meio.

#### `effort`

[Oficial] `effort` é um override local de raciocínio. Ele substitui o esforço da sessão enquanto aquele worker está ativo, mas não ganha de `CLAUDE_CODE_EFFORT_LEVEL`.

Boa prática:

- `low` ou `medium` para pesquisa barata
- `high` para implementação geral sensível
- `xhigh` ou `max` apenas para workers que realmente precisam de mais profundidade

#### `isolation`

[Oficial] `isolation: worktree` é o melhor controle nativo contra colisão de edição entre workers.

Nuances relevantes:

- cada worker ganha cópia temporária do repositório
- se terminar sem mudanças, o worktree tende a ser limpo automaticamente
- se houver crash ou interrupção, o cleanup posterior respeita `cleanupPeriodDays`
- `.worktreeinclude` também afeta worktrees de subagents
- `worktree.baseRef` muda de onde o worktree nasce: `fresh` ou `head`

#### `initialPrompt`

[Oficial] É um campo raro e poderoso, mas só vale para a sessão principal.

Uso correto:

- bootstrapar um agente operador rodando com `--agent`
- injetar instruções iniciais que devem sempre acontecer antes do input do usuário
- padronizar workflows onde o agente principal deve começar com ritual fixo

Uso incorreto:

- esperar efeito quando o agente for spawnado como subagent normal

## 5. Restrições por tipo de origem

### 5.1 Plugin subagents

[Oficial] Quando um agente vem de plugin, estes campos são ignorados:

- `hooks`
- `mcpServers`
- `permissionMode`

Leitura prática: plugins são bons para distribuição, mas não são o lugar ideal para regras finas de governança por agente.

### 5.2 CLI `--agents`

[Oficial] Aceita os mesmos campos de frontmatter e usa `prompt` no lugar do corpo Markdown.

Casos ideais:

- automação efêmera
- benchmark de modelos e permissões
- sessão provisionada por script

### 5.3 SDK `AgentDefinition`

[Oficial] O guia do SDK documenta explicitamente estes campos: `description`, `prompt`, `tools`, `disallowedTools`, `model`, `skills`, `memory`, `mcpServers`, `maxTurns`, `background`, `effort` e `permissionMode`.

[Lacuna] No material do SDK lido para esta pesquisa, `hooks`, `isolation`, `color` e `initialPrompt` não aparecem como campos documentados do `AgentDefinition`. Portanto, trate esses campos como centrados em filesystem/CLI até validação adicional na referência específica da linguagem usada.

## 6. Ordens de precedência que realmente importam

### 6.1 Precedência de escopo

[Oficial]

1. managed
2. `--agents`
3. `.claude/agents/`
4. `~/.claude/agents/`
5. plugin

### 6.2 Precedência de modelo

[Oficial]

1. `CLAUDE_CODE_SUBAGENT_MODEL`
2. override por invocação
3. `model` do agente
4. modelo da sessão pai

### 6.3 Precedência de permissões

[Oficial]

- `deny` vence `ask` e `allow`
- `permissionMode` do pai pode engolir o do subagent em `bypassPermissions`, `acceptEdits` e `auto`
- hooks podem endurecer comportamento mesmo quando a tool está tecnicamente permitida

### 6.4 Precedência de execução

[Oficial]

- `CLAUDE_CODE_FORK_SUBAGENT=1` muda a semântica geral de spawning
- `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1` pode re-sincronizar spawns
- `background: true` sugere execução concorrente, mas o runtime ainda considera o contexto geral

## 7. Settings e env vars que também configuram subagents

### 7.1 Settings relevantes

| Setting | Efeito sobre subagents |
| --- | --- |
| `agent` | faz a sessão principal rodar como um subagent nomeado |
| `permissions.deny` | pode bloquear agentes específicos via `Agent(nome)` |
| `cleanupPeriodDays` | controla retenção de transcripts e cleanup de worktrees órfãos |
| `worktree.baseRef` | define se `isolation: worktree` nasce de `fresh` ou `head` |

### 7.2 Env vars relevantes

| Variável | Efeito |
| --- | --- |
| `CLAUDE_CODE_FORK_SUBAGENT` | habilita forked subagents e altera a arquitetura de spawning |
| `CLAUDE_CODE_SUBAGENT_MODEL` | override global do modelo de subagents |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | desliga background tasks e afeta spawns concorrentes |
| `CLAUDE_AUTO_BACKGROUND_TASKS` | força backgrounding automático de tarefas longas |
| `CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS` | timeout de stall para subagents em background |
| `CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY` | controla quantos subagents e read-only tools podem rodar em paralelo |
| `TASK_MAX_OUTPUT_LENGTH` | limita tamanho do output devolvido pelo subagent |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | muda o gatilho de compaction também para subagents |
| `CLAUDE_CODE_MAX_TURNS` | teto global quando nenhum limite explícito é passado |
| `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` | no SDK non-interactive, desabilita built-ins como Explore e Plan |

## 8. Combinações avançadas recomendadas

### 8.1 Reviewer estrito e barato

```markdown
---
name: security-reviewer
description: Security-focused reviewer. Use proactively after any auth, secrets, network, storage, or permission change.
tools: Read, Grep, Glob, Bash
model: sonnet
permissionMode: plan
maxTurns: 10
effort: high
color: yellow
---

You are a security-focused reviewer.
Review only. Do not modify files.
Prioritize credential leakage, auth gaps, unsafe shell use, permission mistakes,
data exposure, and missing validation.
```

Por que funciona:

- forte descrição de roteamento
- conjunto de tools pequeno
- `plan` reforça modo read-only
- `maxTurns` evita investigações infinitas

### 8.2 Refactor worker isolado por worktree

```markdown
---
name: refactor-worker
description: Implementation specialist for medium-to-large refactors. Use when edits may collide with other tasks.
tools: Read, Edit, Write, Grep, Glob, Bash
model: sonnet
permissionMode: acceptEdits
maxTurns: 20
memory: project
effort: high
isolation: worktree
color: blue
hooks:
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-local-checks.sh"
---

Refactor conservatively. Preserve public behavior unless the task explicitly
allows a behavior change. Update project memory with any reusable findings.
```

Por que funciona:

- worktree reduz colisão entre workers
- `memory: project` transforma achados em conhecimento compartilhável
- hook pós-edição valida rápido o slice tocado

### 8.3 Browser tester com MCP inline

```markdown
---
name: browser-tester
description: Real browser validation specialist. Use for flows that require screenshots, DOM inspection, and interaction checks.
disallowedTools: Write, Edit
background: true
effort: medium
isolation: worktree
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
color: cyan
---

Validate user-visible behavior in a real browser. Prefer concise findings,
reproduction steps, and screenshot-backed conclusions.
```

Por que funciona:

- evita expor Playwright ao contexto principal
- bloqueia escrita direta no repositório
- roda bem como worker concorrente

### 8.4 Coordenador para rodar como thread principal

```markdown
---
name: coordinator
description: Session lead that decomposes work and coordinates specialist agents.
tools: Agent(worker, researcher, reviewer), Read, Grep, Glob, Bash
model: opus
initialPrompt: Always decompose large work into explicit sub-tasks, delegate aggressively, and synthesize only decision-grade output.
effort: high
color: purple
---

You are the session coordinator. Keep the main thread focused on routing,
decision-making, and synthesis. Delegate exploration and verbose work.
```

Use este agente com:

```bash
claude --agent coordinator
```

Aqui `initialPrompt` passa a ter efeito real e `Agent(worker, researcher, reviewer)` vira a cerca de spawning.

## 9. Anti-patterns avançados

- usar `memory` em agentes que você pretende manter estritamente read-only sem notar que `Write` e `Edit` serão habilitados
- distribuir por plugin um agente que depende de `hooks`, `mcpServers` ou `permissionMode`
- definir `background: true` para workers que inevitavelmente precisarão de prompts de permissão ou de perguntas ao usuário
- usar `description` vaga e depois culpar o orquestrador por não delegar direito
- confiar só em prompt para restringir comportamento quando `tools`, `permissions` ou hooks fariam o enforcement real
- usar `isolation: worktree` sem considerar bootstrap do ambiente no worktree novo
- esperar que `initialPrompt` modifique o comportamento de um spawn normal de subagent
- assumir que o SDK suporta todos os mesmos campos avançados do filesystem sem validar a referência específica da linguagem

## 10. Recomendação final de arquitetura

Se a meta é usar subagents no nível mais avançado que faz sentido em produção, a ordem recomendada é:

1. desenhar descrições discriminativas e tool envelopes mínimos
2. usar `permissionMode`, hooks e deny rules como camadas complementares de controle
3. reservar `memory` para agentes que realmente se beneficiam de memória persistente
4. usar `mcpServers` inline para capacidades especializadas, não para inflar o contexto global
5. adotar `isolation: worktree` para workers de implementação paralela
6. usar `initialPrompt` e `Agent(...)` apenas em agentes coordenadores rodando como sessão principal

Em resumo: a configuração avançada de subagents não é escolher muitos campos; é combinar poucos campos de alto impacto com a semântica correta de execução, precedência e isolamento.