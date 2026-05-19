# Ferramentas novas e configuração

Este documento complementa [Subagents](./README.md) e [Configuração avançada de subagents](./configuracao-avancada.md) com foco em ferramentas mais novas, menos óbvias ou de maior alavancagem para workflows avançados.

O recorte aqui não é listar tudo de novo. O objetivo é responder a três perguntas práticas:

1. quais ferramentas recentes ou subutilizadas realmente mudam a arquitetura de um subagent
2. quais dessas ferramentas fazem sentido dentro de subagents e quais fazem mais sentido na thread principal
3. como configurar subagents e permissões para usar essas ferramentas de forma segura e útil

## 1. Leitura de evidência usada neste arquivo

- `Oficial`: explicitamente documentado pela Anthropic
- `Corroborado`: sustentado por múltiplas páginas oficiais e pela superfície real do produto
- `Inferência arquitetural`: conclusão operacional razoável, mas não contrato formal
- `Lacuna`: área em que a documentação não fecha completamente o comportamento

## 2. O que conta como ferramenta nova ou de alto valor

Neste apêndice, tratei como prioritárias as ferramentas que atendem a pelo menos um destes critérios:

- ampliam muito a capacidade do subagent além de `Read` + `Grep` + `Bash`
- são recentes na superfície do produto ou ainda pouco difundidas na comunidade
- exigem configuração específica para funcionar bem
- mudam o desenho do workflow, custo, latência ou governança

As mais importantes nesse grupo são:

- `LSP`
- `Monitor`
- `WebSearch`
- `WebFetch`
- `ToolSearch`
- `ListMcpResourcesTool` e `ReadMcpResourceTool`
- `PowerShell`
- `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`, `TaskStop`
- `SendMessage`
- `CronCreate`, `CronList`, `CronDelete`
- `RemoteTrigger`

## 3. Ferramentas novas com maior valor para subagents

### 3.1 `LSP`

[Oficial] `LSP` entrega code intelligence por language server: definição, referências, símbolos, implementações, type info e diagnósticos automáticos após edições.

Por que muda subagents:

- reduz a dependência de `grep` para navegação semântica
- melhora revisores, refactor workers e validadores de mudanças
- torna subagents especialistas mais precisos em linguagens com bom suporte LSP

Pré-requisitos reais:

- instalar um plugin de code intelligence
- ter o binário do language server disponível no `PATH`

Melhores usos:

- `code-reviewer` com foco em referências e warnings
- `refactor-worker` que precisa navegar por símbolos e implementações
- `type-fixer` para corrigir erros introduzidos por edição

Risco principal:

- assumir que `LSP` substitui totalmente `Read` e `Grep`; na prática ele complementa, não elimina a leitura textual

### 3.2 `Monitor`

[Oficial] `Monitor` executa um comando em background e alimenta cada linha de saída de volta ao Claude, permitindo reação a logs, file changes e status assíncrono dentro da mesma conversa.

Por que muda subagents:

- permite observabilidade reativa sem polling pesado
- é melhor que reexecutar comandos em loop quando o objetivo é observar mudança incremental
- combina muito bem com workers de incident response, CI babysitting e runtime investigation

Restrições documentadas:

- usa as mesmas regras de permissão de `Bash`
- não está disponível em Bedrock, Vertex e Foundry
- também não está disponível quando `DISABLE_TELEMETRY` ou `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` estão ativos

Leitura arquitetural:

- `Monitor` é uma das ferramentas mais interessantes para subagents de runtime, mas sua utilidade depende muito do provider e das políticas de ambiente

### 3.3 `WebSearch` e `WebFetch`

[Oficial] `WebSearch` encontra resultados; `WebFetch` lê conteúdo de uma URL com extração orientada por prompt.

Por que mudam subagents:

- habilitam pesquisadores externos, workers de documentação e agentes de triagem de incidentes
- reduzem a necessidade de acoplar MCP só para busca e documentação pública
- funcionam muito bem em subagents, porque o ruído externo fica isolado do contexto principal

Restrições e nuances:

- `WebFetch` é lossy por design; a resposta depende do prompt de extração
- `WebFetch` pede permissão por domínio em `default` e `acceptEdits`
- `WebSearch` não lê a página, só retorna resultados; a leitura real depende de `WebFetch`
- `WebSearch` está disponível na Claude API e Foundry; em Vertex funciona com Claude 4; Bedrock não expõe essa busca server-side

Melhor padrão:

- delegar pesquisa externa a um subagent e trazer só a síntese de alto sinal de volta

### 3.4 `ToolSearch`

[Oficial] `ToolSearch` carrega ferramentas deferidas quando tool search está habilitado em ecossistemas MCP grandes.

Por que muda subagents:

- permite que um worker especializado descubra só as tools MCP realmente necessárias
- reduz custo de contexto em cenários com muitos servidores e muitas tools
- reforça a ideia de que subagent especializado deve carregar menos, não mais

Quando faz mais sentido:

- subagents que operam em ambientes com muitos MCP servers
- agentes de integração, platform engineering e automação interna

Quando faz menos sentido:

- projetos pequenos com poucas tools estáveis e sempre usadas

### 3.5 `ListMcpResourcesTool` e `ReadMcpResourceTool`

[Oficial] Essas ferramentas permitem listar e ler resources expostos por MCP servers conectados.

Por que mudam subagents:

- separam leitura de recursos estruturados do uso de tools acionáveis
- ajudam workers de auditoria, diagnóstico e conformidade a ler contexto remoto sem necessariamente executar ações
- combinam muito bem com `mcpServers` inline em subagents especializados

Padrão forte:

- worker com MCP escopado usa resource tools para descoberta e leitura; se precisar agir, usa as tools do próprio servidor depois

### 3.6 `PowerShell`

[Oficial] `PowerShell` roda comandos nativamente em PowerShell. Em Windows, isso elimina a dependência de Git Bash para muitos fluxos.

Por que muda subagents:

- aumenta muito a qualidade de automação em ambientes corporativos Windows
- melhora integração com scripts administrativos, registry, serviços e ecossistema Microsoft
- evita traduções frágeis de comandos Windows para Bash

Configuração necessária:

- `CLAUDE_CODE_USE_POWERSHELL_TOOL=1` quando o ambiente exigir opt-in

Boa prática:

- se o time opera em Windows, trate `PowerShell` como tool de primeira classe, não como fallback

### 3.7 Task tools: `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`, `TaskStop`

[Oficial] Essa família substitui gradualmente `TodoWrite` e formaliza a checklist/task list da sessão.

Por que muda subagents e coordenação:

- melhora workflows de coordenação, decomposição e rastreio de progresso
- abre espaço para agentes coordenadores mais estruturados
- fica especialmente relevante quando combinado com agent teams

Leitura prática:

- para subagents focados, o valor é moderado
- para agentes coordenadores rodando como thread principal, o valor é alto

## 4. Ferramentas novas que são mais úteis na thread principal ou em agent teams

### 4.1 `SendMessage`

[Oficial] `SendMessage` envia mensagem para teammates de agent teams ou retoma um subagent por `agentId`. Só está disponível quando `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.

Leitura arquitetural:

- não é uma tool que torna um subagent isolado melhor por si só
- ela é muito mais importante para coordenação entre sessões, retomada de contexto e workflows de longa duração

Conclusão prática:

- excelente para lead/coordinator em team mode
- valor limitado para subagents convencionais, exceto no caso de retomada explícita de worker

### 4.2 `CronCreate`, `CronList`, `CronDelete`

[Oficial] São as ferramentas por trás de `/loop` e de agendamentos session-scoped.

Leitura arquitetural cuidadosa:

- o contrato oficial é centrado na sessão atual
- para a maioria dos casos, o valor operacional real é maior na thread principal do que em subagents especializados
- quando o objetivo é reação contínua em vez de polling, `Monitor` costuma ser uma opção melhor

Use quando:

- você quer polling leve, temporário e session-scoped

Evite quando:

- precisa de persistência real fora da sessão
- o caso já pede `Routines`, Desktop scheduled tasks ou GitHub Actions

### 4.3 `RemoteTrigger`

[Oficial] `RemoteTrigger` cria, atualiza, executa e lista Routines em claude.ai. Não está disponível em Bedrock, Vertex e Foundry.

Leitura prática:

- fortíssimo para automação cloud persistente
- muito mais útil para agentes operadores e coordenadores do que para workers locais de código

### 4.4 `PushNotification`

[Oficial] Notifica desktop e telefone quando Remote Control está conectado.

Valor real:

- útil como conveniência operacional para tarefas longas
- baixo impacto arquitetural em comparação com `Monitor`, `LSP` ou `ToolSearch`

## 5. Ferramentas que parecem úteis, mas têm limitações importantes em subagents

### 5.1 `EnterWorktree` e `ExitWorktree`

[Oficial] Não estão disponíveis para subagents.

Conclusão:

- para isolamento em subagents, o caminho correto é `isolation: worktree` no frontmatter, não essas tools

### 5.2 `Agent`

[Oficial] Subagents não spawnam outros subagents.

Conclusão:

- `Agent` é central para a thread principal e para sessões rodando com `--agent`
- dentro de um subagent, seu valor prático é nulo para fan-out adicional

### 5.3 `ShareOnboardingGuide`

[Oficial] Ferramenta útil para onboarding compartilhado, mas ligada a fluxo de equipe e assinatura claude.ai.

Conclusão:

- relevante para enablement e distribuição de conhecimento
- pouco relevante para desenho de subagents de trabalho técnico cotidiano

## 6. Quais ferramentas novas eu priorizaria primeiro

### Prioridade alta

- `LSP`
- `Monitor`
- `WebSearch`
- `WebFetch`
- `ToolSearch`
- `ListMcpResourcesTool`
- `ReadMcpResourceTool`
- `PowerShell`

### Prioridade média

- `TaskCreate`, `TaskGet`, `TaskList`, `TaskUpdate`, `TaskStop`
- `SendMessage`
- `CronCreate`, `CronList`, `CronDelete`

### Prioridade situacional

- `RemoteTrigger`
- `PushNotification`
- `ShareOnboardingGuide`

## 7. Configurações recomendadas por padrão de uso

### 7.1 Revisor com code intelligence

```markdown
---
name: typed-code-reviewer
description: Type-aware reviewer. Use proactively after edits in strongly typed codebases.
tools: Read, Grep, Glob, LSP
model: sonnet
permissionMode: plan
maxTurns: 10
effort: high
color: yellow
---

Review code using semantic navigation whenever possible.
Prioritize type errors, broken references, unsafe changes, and API drift.
```

Quando usar:

- TypeScript, Go, Java, C#, Rust e stacks com language server maduro

### 7.2 Investigador de runtime com monitoramento reativo

```markdown
---
name: runtime-watcher
description: Runtime and logs investigator. Use for long-running builds, dev servers, log watching, and CI babysitting.
tools: Read, Grep, Glob, Bash, Monitor
model: sonnet
permissionMode: default
maxTurns: 12
background: true
effort: medium
color: cyan
hooks:
  PreToolUse:
    - matcher: "Bash|Monitor"
      hooks:
        - type: command
          command: "./scripts/validate-runtime-commands.sh"
---

Prefer monitors over manual polling when the source emits useful incremental output.
Summarize only actionable signals, not every log line.
```

Observação:

- este padrão só vale em providers onde `Monitor` exista

### 7.3 Pesquisador externo de documentação e incidentes

```markdown
---
name: web-researcher
description: External documentation and issue researcher. Use for public docs, release notes, and troubleshooting references.
tools: Read, WebSearch, WebFetch
model: haiku
permissionMode: default
maxTurns: 8
effort: medium
color: blue
---

Search first, fetch second, then summarize the highest-signal findings.
Always distinguish documented behavior from community claims.
```

Por que funciona:

- isola ruído web
- usa modelo barato para pesquisa externa
- traz de volta só síntese útil

### 7.4 Auditor de recursos MCP

```markdown
---
name: mcp-resource-auditor
description: MCP resource auditor. Use when a task depends on structured remote resources, catalogs, metadata, or externally exposed context.
tools: Read, ListMcpResourcesTool, ReadMcpResourceTool, ToolSearch
mcpServers:
  - github
model: sonnet
permissionMode: plan
maxTurns: 10
effort: medium
color: green
---

List available resources first, read only the ones that matter, and avoid loading unrelated tools or resources into context.
```

Leitura prática:

- ótimo para ecossistemas MCP grandes
- ruim para projetos sem MCP estruturado

### 7.5 Operador Windows nativo

```markdown
---
name: windows-operator
description: Windows automation specialist. Use for PowerShell-native administration, build scripts, services, registry, and enterprise automation.
tools: Read, Grep, Glob, PowerShell
model: sonnet
permissionMode: default
maxTurns: 10
effort: medium
color: purple
---

Prefer native PowerShell idioms over Bash translation. Be explicit about services, registry paths, and Windows-specific side effects.
```

## 8. Configuração de permissões para essas ferramentas

O erro comum é liberar uma tool nova no subagent, mas esquecer que o gargalo real está nas permission rules da sessão.

Exemplo de `settings.json` para um setup mais avançado:

```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "WebFetch(domain:docs.anthropic.com)",
      "WebFetch(domain:code.claude.com)",
      "Monitor(tail -f *)",
      "PowerShell(Get-ChildItem *)",
      "PowerShell(git status)",
      "Read(/src/**)",
      "Read(/docs/**)"
    ],
    "deny": [
      "Bash(curl *)",
      "Bash(wget *)",
      "PowerShell(Remove-Item *)",
      "WebFetch(domain:untrusted.example)"
    ]
  },
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Leitura arquitetural:

- liberar `WebFetch` por domínio é mais seguro do que liberar `curl` indiscriminadamente
- `Monitor` herda a semântica de permissão de `Bash`, então ele precisa do mesmo cuidado
- `PowerShell` deve ser governado como tool de execução real, não como mera conveniência de shell

## 9. Arquivo de configuração de referência

Se eu tivesse que criar um subagent novo hoje para aproveitar o que há de mais forte nessa superfície, eu começaria com algo assim:

```markdown
---
name: platform-investigator
description: Advanced platform investigator. Use for code intelligence, runtime watching, public documentation lookup, and MCP-backed environment inspection.
tools: Read, Grep, Glob, LSP, Monitor, WebSearch, WebFetch, ListMcpResourcesTool, ReadMcpResourceTool, ToolSearch, Bash
model: sonnet
permissionMode: default
maxTurns: 14
background: true
effort: high
isolation: worktree
color: cyan
hooks:
  PreToolUse:
    - matcher: "Bash|Monitor"
      hooks:
        - type: command
          command: "./scripts/validate-runtime-commands.sh"
---

You are an advanced platform investigator.

Use LSP for semantic code navigation when available.
Use Monitor instead of repeated polling when incremental runtime output exists.
Use WebSearch and WebFetch for official documentation and recent release evidence.
Use MCP resource tools before broad MCP action when structured remote context is available.
Return concise conclusions, explicit evidence levels, and only the minimum supporting detail the parent session needs.
```

Por que essa configuração é forte:

- combina navegação semântica, observabilidade, pesquisa externa e contexto remoto estruturado
- preserva o princípio de trazer de volta apenas síntese útil
- usa `isolation: worktree` para reduzir colisão de alterações
- deixa o enforcement pesado em hooks e permissions, não só em prompt

## 10. Recomendação final

Se você já domina `Read`, `Grep`, `Glob`, `Edit` e `Bash`, as maiores alavancas novas para subagents hoje são:

1. `LSP` para precisão semântica
2. `Monitor` para observabilidade reativa
3. `WebSearch` + `WebFetch` para pesquisa externa isolada
4. `ToolSearch` + MCP resource tools para ecossistemas MCP grandes
5. `PowerShell` para automação séria em Windows

O ponto central não é só adicionar tools ao array `tools`. É desenhar um worker em que essas tools façam sentido juntas, com permissão, provider, hooks e isolamento coerentes.