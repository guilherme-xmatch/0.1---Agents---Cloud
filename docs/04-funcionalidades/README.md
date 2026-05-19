# Funcionalidades, comandos e superfícies

Este documento organiza o mapa funcional do Claude Code por famílias de capacidade, com ênfase em recursos oficiais, superfícies de execução e limitações de disponibilidade.

Leitura complementar:

- [Arquitetura central](../01-arquitetura-central/README.md)
- [Instalação, setup e operação](../02-instalacao-operacao/README.md)
- [Performance, custo e confiabilidade](../08-performance-custo/README.md)

## 1. Mapa funcional do produto

O Claude Code já não é apenas “uma conversa no terminal”. O mapa funcional oficial cobre pelo menos estes blocos:

| Bloco | Exemplos relevantes |
| --- | --- |
| Sessão interativa | CLI, VS Code, JetBrains, Desktop, Web |
| Ferramentas nativas | Read, Edit, Write, Bash, PowerShell, WebFetch, WebSearch, LSP |
| Controle da conversa | `/clear`, `/resume`, `/branch`, `/compact`, `/context` |
| Planejamento e esforço | `/plan`, `/model`, `/effort`, `opusplan` |
| Paralelismo | subagents, worktrees, agent view, agent teams, `/batch` |
| Automação | hooks, routines, cron da sessão, monitor |
| Integração externa | MCP, Chrome, Slack, CI/CD, GitHub/GitLab |
| Operação e debug | `/doctor`, `/debug`, `/hooks`, `/mcp`, `/status`, `/usage` |
| Segurança e governança | permissions, sandbox, managed settings, OTel |

## 2. Famílias de comandos

[Oficial] O menu `/` mistura dois tipos distintos:

- comandos nativos do CLI
- bundled skills, que são workflows prompt-based empacotados

### 2.1 Comandos de setup e configuração

- `/init`
- `/memory`
- `/permissions`
- `/mcp`
- `/agents`
- `/config`
- `/keybindings`
- `/statusline`

### 2.2 Comandos de operação da conversa

- `/clear`
- `/resume`
- `/branch`
- `/rename`
- `/copy`
- `/export`

### 2.3 Comandos de contexto e qualidade

- `/context`
- `/compact`
- `/diff`
- `/review`
- `/security-review`
- `/simplify`

### 2.4 Planejamento e desempenho do modelo

- `/plan`
- `/model`
- `/effort`
- `/fast`
- `/goal`

### 2.5 Paralelismo e background work

- `/background` ou `/bg`
- `/tasks`
- `/batch`
- `claude agents`

### 2.6 Operação remota e cloud

- `/remote-control`
- `/teleport`
- `/schedule`
- `/autofix-pr`
- `/ultraplan`
- `/ultrareview`

### 2.7 Diagnóstico e suporte

- `/doctor`
- `/debug`
- `/feedback`
- `/release-notes`

## 3. Ferramentas nativas do agente

[Oficial] As principais tools embutidas podem ser lidas por categoria:

### 3.1 Arquivos e código

- `Read`
- `Edit`
- `Write`
- `NotebookEdit`
- `Glob`
- `Grep`
- `LSP`

### 3.2 Execução

- `Bash`
- `PowerShell`
- `Monitor`

### 3.3 Web e externo

- `WebFetch`
- `WebSearch`
- `ReadMcpResourceTool`
- `ListMcpResourcesTool`

### 3.4 Orquestração

- `Agent`
- `Skill`
- `AskUserQuestion`
- `TaskCreate`, `TaskList`, `TaskUpdate`, `TaskStop`
- `SendMessage`, `TeamCreate`, `TeamDelete`
- `CronCreate`, `CronList`, `CronDelete`

### 3.5 Workflows cloud e notificações

- `RemoteTrigger`
- `PushNotification`
- `ShareOnboardingGuide`

## 4. Superfícies de uso

## 4.1 CLI

[Oficial] Continua sendo a superfície mais completa para:

- trabalho local com total acesso ao repo
- customização fina de permissões
- uso profundo de hooks, MCP e worktrees
- automação com `-p` e Agent SDK

## 4.2 VS Code

[Oficial] O extension oferece:

- diff side-by-side com aprovação de edição
- `@` mentions com faixas de linha
- múltiplas conversas em tabs
- permission mode selector
- menu `/` integrado
- plugin management gráfico
- reuso de sessões remotas do claude.ai em certos cenários

## 4.3 JetBrains

[Oficial] A proposta é similar ao VS Code, com integração IDE-first e uso do mesmo runtime do Claude Code.

## 4.4 Desktop

[Oficial] A superfície desktop agrega valor quando o time precisa de:

- múltiplas sessões com isolamento Git
- layout de painéis
- terminal integrado e editor
- diff visual
- app previews
- scheduled tasks locais

## 4.5 Claude Code on the web

[Oficial] É a superfície cloud da Anthropic para:

- conectar repositórios GitHub
- executar sessões sem setup local
- criar PRs e revisar saídas no browser
- routines, code review cloud e fluxos remotos

## 5. Funcionalidades operacionais centrais

## 5.1 Sessões e retomada

[Oficial] Sessões ficam associadas ao diretório/worktree. Há suporte a:

- `--continue`
- `--resume`
- `/resume`
- `/branch`
- recaps ao retornar ao terminal
- retomada por PR URL em releases recentes

## 5.2 Checkpointing e rewind

[Oficial] Antes de editar arquivos, o Claude Code cria checkpoints. Isso habilita:

- `/rewind`
- undo local independente de Git
- resumo parcial da conversa até um ponto escolhido

## 5.3 Permission modes

[Oficial] Modos centrais:

- `default`
- `acceptEdits`
- `plan`
- `auto` em research preview
- `dontAsk`
- `bypassPermissions`

O importante é entender que o modo altera o envelope operacional do agente, não só a UX de prompts.

## 5.4 Context tools

[Oficial] O produto já tem primitives dedicadas para contexto:

- `/context`
- `/compact`
- compaction automática
- skill listing budget
- tool search para MCP
- skills on-demand
- subagents com contexto isolado

## 5.5 Worktrees

[Oficial] Worktrees são uma funcionalidade-chave para paralelismo seguro:

- `--worktree`
- `EnterWorktree`
- isolamento por branch/diretório
- cópia seletiva de arquivos ignorados via `.worktreeinclude`

## 6. Recursos avançados de alto valor

Esta é a parte que costuma ficar fora de visões superficiais do produto.

### 6.1 Agent View e background sessions

[Oficial, research preview em 2026] `claude agents` centraliza sessões rodando, bloqueadas ou concluídas, e permite despachar novas sessões em background com defaults próprios.

### 6.2 Agent Teams

[Oficial, experimental] Times de sessões independentes com task list compartilhado, mailbox entre agentes e coordenação multi-sessão.

### 6.3 Monitor tool

[Oficial] Permite acompanhar logs, polling e saídas em background e alimentar linhas de output de volta na conversa. É um passo importante rumo a workflows reativos sem polling manual do usuário.

### 6.4 Goal-oriented execution

[Oficial] `/goal` transforma a conversa em loop persistente até condição explícita de conclusão.

### 6.5 Routines

[Oficial, research preview] Rotinas cloud com gatilhos por schedule, API e GitHub, executadas em infraestrutura gerenciada da Anthropic.

### 6.6 Channels

[Oficial, research preview] MCP servers capazes de empurrar mensagens para a sessão viva, viabilizando arquitetura event-driven.

### 6.7 Ultraplan e Ultrareview

[Oficial, preview] Fluxos cloud especializados para planejamento profundo e code review multiagente.

### 6.8 Chrome e Computer Use

[Oficial, beta/preview conforme superfície] Integração com browser e automação GUI para fechar o ciclo em tarefas visuais e testes de aplicação.

### 6.9 Code intelligence por plugins

[Oficial] LSP plugins transformam exploração textual em navegação semântica, reduzindo leitura desnecessária e melhorando validação pós-edição.

### 6.10 Team onboarding e insights

[Oficial] O produto já possui comandos que empacotam setup e analisam histórico de uso para onboarding e melhoria contínua.

## 7. Observabilidade, logs e debugging

### 7.1 Debug local

- `/debug`
- `--debug`
- `CLAUDE_CODE_DEBUG_LOGS_DIR`
- `CLAUDE_CODE_DEBUG_LOG_LEVEL`

### 7.2 Inspeção operacional in-product

- `/status`
- `/doctor`
- `/hooks`
- `/mcp`
- `/context`
- `/usage`

### 7.3 OpenTelemetry

[Oficial] OTel cobre:

- métricas
- logs/eventos
- traces beta

Com spans para `interaction`, `llm_request`, `tool`, `tool.execution`, `tool.blocked_on_user` e, em alguns contextos, hooks.

## 8. Integrações de plataforma

### 8.1 CI/CD e code review

- GitHub Actions
- GitLab CI/CD
- `/install-github-app`
- `/autofix-pr`
- code review local e cloud

### 8.2 IDE e navegador

- VS Code
- JetBrains
- Chrome
- Desktop

### 8.3 Messaging e colaboração

- Slack
- Channels como Telegram, Discord e iMessage em preview

## 9. Restrições operacionais importantes

| Recurso | Restrições relevantes |
| --- | --- |
| Channels | não disponível em Bedrock, Vertex e Foundry |
| Routines | requer superfície Anthropic-first com Claude Code on the web |
| Monitor | indisponível em Bedrock, Vertex e Foundry |
| Agent Teams | experimental e desabilitado por padrão |
| Auto Mode | research preview |
| Computer Use | preview/research preview conforme superfície |

## 10. Leitura prática

O jeito mais produtivo de olhar para o mapa funcional é separar três camadas:

1. produtividade diária local: CLI, IDE, context, permissions, MCP, skills
2. orquestração avançada: subagents, worktrees, monitor, agent view, hooks
3. automação e offload: web, routines, code review cloud, ultraplan, ultrareview

Quando um time entende essa divisão, deixa de usar o produto como chat e passa a usá-lo como plataforma de engenharia assistida.