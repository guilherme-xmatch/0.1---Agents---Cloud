# Instalação, setup e operação

Este documento trata da entrada em produção: instalação, autenticação, arquivos de configuração, versionamento, operação diária e rollout corporativo.

Documentos relacionados:

- [Arquitetura central](../01-arquitetura-central/README.md)
- [Funcionalidades, comandos e superfícies](../04-funcionalidades/README.md)
- [Performance, custo e confiabilidade](../08-performance-custo/README.md)

## 1. Pré-requisitos

[Oficial] O Claude Code pode ser consumido por CLI, VS Code, JetBrains, Desktop e Web, mas os pré-requisitos práticos variam por superfície e provider.

Pré-requisitos comuns:

- acesso a uma conta Claude.ai, Claude Console ou provider third-party suportado
- ambiente com acesso ao repositório e ferramentas de build
- shell funcional no sistema operacional de destino
- para extensões avançadas, capacidade de instalar plugins, MCP servers e, opcionalmente, language servers

No Windows, a documentação recente destaca um avanço importante: o produto já opera sem dependência obrigatória de Git Bash, usando PowerShell quando necessário.

## 2. Modos de instalação

[Oficial] A documentação aponta três caminhos principais para a CLI:

- instalação nativa recomendada
- Homebrew
- WinGet

Além disso, o usuário pode começar pelo VS Code extension, Desktop app ou Web, dependendo do plano e do ambiente.

### Estratégia recomendada por perfil

| Perfil | Caminho recomendado |
| --- | --- |
| Dev individual | CLI nativa + VS Code ou JetBrains |
| Time de aplicação | CLI + `.claude/` versionado + política de permissões |
| Plataforma interna | CLI + managed settings + sandbox + OTel |
| Uso cloud-first | Claude Code on the web + rotinas + integrações GitHub |

## 3. Autenticação

[Oficial] O produto suporta várias formas de autenticação:

- Claude Pro ou Max via Claude.ai
- Claude for Teams ou Enterprise via Claude.ai
- Claude Console com billing por API
- Amazon Bedrock
- Google Vertex AI
- Microsoft Foundry
- Claude Platform on AWS

### 3.1 Ordem de precedência de credenciais

[Oficial] Quando múltiplas credenciais coexistem, a precedência relevante é:

1. credenciais de provider cloud, quando habilitadas
2. `ANTHROPIC_AUTH_TOKEN`
3. `ANTHROPIC_API_KEY`
4. `apiKeyHelper`
5. `CLAUDE_CODE_OAUTH_TOKEN`
6. OAuth persistido via `/login`

Implicação prática: ambientes mistos frequentemente falham por “credencial errada vencer por precedência”, não por falta de suporte.

### 3.2 Considerações operacionais

- `ANTHROPIC_API_KEY` toma precedência sobre subscription auth quando aprovado
- `apiKeyHelper` é valioso para credenciais efêmeras e vaults internos
- `claude setup-token` é o caminho oficial para CI e ambientes sem browser
- Desktop e sessões remotas Anthropic-first usam OAuth, não `apiKeyHelper`

## 4. Estrutura de configuração

## 4.1 Escopos

[Oficial] O sistema de escopo é central para o produto:

| Escopo | Localização típica | Efeito |
| --- | --- | --- |
| Managed | server-managed, plist/registry ou `managed-settings.json` | enforcement organizacional |
| User | `~/.claude/` | preferências e capacidades pessoais |
| Project | `.claude/` | configuração compartilhada do repositório |
| Local | `.claude/settings.local.json` | overrides pessoais por projeto |

### Ordem de precedência

[Oficial]

1. Managed
2. argumentos de CLI
3. Local
4. Project
5. User

Observação: arrays de permissão, sandbox e alguns outros domínios podem mesclar em vez de simplesmente sobrescrever.

## 4.2 Arquivos principais

| Arquivo | Papel |
| --- | --- |
| `~/.claude/settings.json` | settings globais do usuário |
| `.claude/settings.json` | settings compartilhados do projeto |
| `.claude/settings.local.json` | settings locais não versionados |
| `~/.claude.json` | estado operacional, auth state, MCP user/local, caches e per-project state |
| `.mcp.json` | MCP project-scoped |
| `CLAUDE.md` ou `.claude/CLAUDE.md` | memória e instruções persistentes |
| `CLAUDE.local.md` | memória local não compartilhada |
| `.claude/agents/` | subagents do projeto |
| `.claude/skills/` | skills do projeto |
| `.claude/rules/` | regras de memória path-specific |

## 4.3 Configurações gerenciadas

[Oficial] Há múltiplos mecanismos de entrega para times:

- server-managed settings pela Anthropic
- macOS plist `com.anthropic.claudecode`
- Windows registry `HKLM\SOFTWARE\Policies\ClaudeCode`
- arquivo em `C:\Program Files\ClaudeCode\managed-settings.json` no Windows
- arquivo em `/etc/claude-code/` em Linux/WSL

Esses mecanismos permitem rollout sem depender de confiança no workspace do desenvolvedor.

## 5. Variáveis de ambiente por domínio

O conjunto de variáveis suportadas é extenso. Em vez de memorizar a lista inteira, vale operar por categoria.

### 5.1 Auth e providers

- `ANTHROPIC_API_KEY`
- `ANTHROPIC_AUTH_TOKEN`
- `CLAUDE_CODE_OAUTH_TOKEN`
- `CLAUDE_CODE_USE_BEDROCK`
- `CLAUDE_CODE_USE_VERTEX`
- `CLAUDE_CODE_USE_FOUNDRY`
- `CLAUDE_CODE_USE_ANTHROPIC_AWS`

### 5.2 Modelos, esforço e contexto

- `ANTHROPIC_MODEL`
- `CLAUDE_CODE_EFFORT_LEVEL`
- `MAX_THINKING_TOKENS`
- `CLAUDE_CODE_DISABLE_1M_CONTEXT`
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`
- `CLAUDE_CODE_MAX_CONTEXT_TOKENS`

### 5.3 MCP, ferramentas e execução

- `ENABLE_TOOL_SEARCH`
- `MCP_TIMEOUT`
- `MCP_TOOL_TIMEOUT`
- `MAX_MCP_OUTPUT_TOKENS`
- `CLAUDE_CODE_USE_POWERSHELL_TOOL`
- `BASH_DEFAULT_TIMEOUT_MS`
- `BASH_MAX_OUTPUT_LENGTH`

### 5.4 Segurança e hardening

- `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`
- `CLAUDE_CODE_MCP_ALLOWLIST_ENV`
- `CLAUDE_CODE_DISABLE_SKILL_SHELL_EXECUTION` via setting correspondente
- `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS`
- `CLAUDE_CODE_DISABLE_CLAUDE_MDS`

### 5.5 Observabilidade

- `CLAUDE_CODE_ENABLE_TELEMETRY`
- `OTEL_METRICS_EXPORTER`
- `OTEL_LOGS_EXPORTER`
- `OTEL_TRACES_EXPORTER`
- `OTEL_LOG_USER_PROMPTS`
- `OTEL_LOG_TOOL_DETAILS`

## 6. Atualização, canais e compatibilidade

[Oficial] A CLI suporta:

- `claude update`
- `claude install latest`
- `claude install stable`
- instalação de versão específica

O setting `autoUpdatesChannel` define `latest` ou `stable`. O setting `minimumVersion` permite piso organizacional. A variável `DISABLE_AUTOUPDATER` desliga auto-update; `DISABLE_UPDATES` bloqueia até updates manuais.

### Implicações arquiteturais

- recursos em weekly digests aparecem com rapidez e podem quebrar suposições de rollout
- políticas corporativas normalmente devem pinar mínimo de versão
- plugins, hooks e agentes customizados devem ser testados contra mudança de versão do runtime

## 7. Operação diária

O workflow operacional típico em times maduros tende a seguir esta ordem:

1. autenticar e validar `/status`
2. ajustar `/permissions`, `/mcp`, `/agents` e `/memory`
3. padronizar `CLAUDE.md`, skills e settings do projeto
4. adicionar hooks e sandbox conforme o risco do repositório
5. habilitar observabilidade e rastrear custo com `/usage` e OTel

### Comandos operacionais mais importantes

- `claude`
- `claude -p`
- `claude -c`
- `claude -r`
- `claude auth login`
- `claude auth status`
- `claude agents`
- `claude mcp list|get|add|remove`

## 8. Operação em times e ambientes corporativos

[Oficial] O setup administrativo pode ser pensado como um mapa de decisão:

1. escolher provider de execução e billing
2. decidir como settings chegam à máquina
3. decidir o que precisa ser enforceable
4. configurar visibilidade de uso, custo e tracing
5. revisar data handling, retenção e compliance

### 8.1 Escolha do provider

| Provider | Quando faz sentido |
| --- | --- |
| Claude Teams/Enterprise | experiência mais completa e menos fricção |
| Claude Console | billing por API e automação orientada a consumo |
| Bedrock | herdar billing e controles AWS |
| Vertex | herdar billing e controles GCP |
| Foundry | herdar billing e controles Azure |

### 8.2 Verificação de política ativa

[Oficial] O comando `/status` mostra a origem de managed settings, incluindo `remote`, `plist`, `HKLM`, `HKCU` ou `file`.

### 8.3 Controles corporativos relevantes

- `allowManagedPermissionRulesOnly`
- `allowManagedMcpServersOnly`
- `allowManagedHooksOnly`
- `strictKnownMarketplaces`
- `blockedMarketplaces`
- `disableAgentView`
- `disableAutoMode`
- `disableRemoteControl`

## 9. Recomendação de setup por maturidade

### Time pequeno

- CLI + IDE extension
- `CLAUDE.md` enxuto
- skills e permissões do projeto
- sem governança pesada, mas com sandbox para repositórios sensíveis

### Time de plataforma

- managed settings
- allowlists explícitas de MCP e plugins
- hooks de compliance
- OTel desde o início
- version floor e política de updates

### Ambiente altamente regulado

- provider cloud alinhado ao compliance existente
- sandbox obrigatória
- `allowManagedPermissionRulesOnly`
- skill shell execution desabilitada para fontes não gerenciadas
- auditoria via OTel e retenção explícita

## 10. O que costuma dar errado em rollout

- misturar subscription auth com `ANTHROPIC_API_KEY` sem perceber a precedência
- tratar `.claude/settings.json` como se fosse política forte em repositório não confiável
- esquecer que `--add-dir` amplia file access, não descoberta total de configuração
- assumir paridade de recursos entre Anthropic e third-party providers
- adotar skills/hook/MCP sem estratégia de governança e sem medição de custo