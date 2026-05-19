# Skills, plugins e extensibilidade

Este documento trata de skills como mecanismo de conhecimento e workflow reutilizável, e de plugins como camada de empacotamento e distribuição dessas extensões.

Leitura complementar:

- [Subagents](../05-subagents/README.md)
- [Hooks](../06-hooks/README.md)
- [MCP e ecossistema de ferramentas](../03-mcp/README.md)

## 1. Skills: conceito e papel arquitetural

[Oficial] Skills estendem o que Claude “sabe fazer” sem adicionar uma tool nova ao runtime. Elas são carregadas pelo `Skill` tool e podem ser invocadas pelo usuário com `/nome` ou, quando permitido, pelo próprio modelo.

O melhor modelo mental é:

- skill não é integração de protocolo
- skill não é enforcement
- skill não é ferramenta nativa nova

Skill é um pacote de conhecimento, instruções e workflow reutilizável.

## 2. O que uma skill resolve bem

- playbooks repetidos
- checklists operacionais
- material de domínio ou estilo
- templates com argumentos
- sequências multietapa orientadas por raciocínio

## 3. Anatomia de uma skill

[Oficial] Cada skill é uma pasta com `SKILL.md` como entrypoint.

Estrutura típica:

```text
my-skill/
├── SKILL.md
├── reference.md
├── examples/
└── scripts/
```

### 3.1 Frontmatter principal

Campos mais relevantes:

| Campo | Papel |
| --- | --- |
| `name` | nome da skill |
| `description` | descrição usada pelo modelo para decidir relevância |
| `when_to_use` | contexto adicional de uso |
| `arguments` | binding posicional nomeado |
| `argument-hint` | UX de autocomplete |
| `disable-model-invocation` | impede invocação automática pelo modelo |
| `user-invocable` | controla visibilidade no menu `/` |
| `allowed-tools` | pré-aprovação de tools durante a skill |
| `model` | override de modelo enquanto a skill roda |
| `effort` | override de effort |
| `context` | `fork` para rodar em subagent |
| `agent` | tipo de subagent quando `context: fork` |
| `hooks` | hooks scoped à skill |
| `paths` | ativação automática condicionada a arquivos |
| `shell` | shell de blocos `!` |

## 4. Descoberta, registro e escopos

[Oficial] Skills podem existir em:

- escopo enterprise
- `~/.claude/skills/`
- `.claude/skills/`
- plugins

Há precedência entre enterprise, personal e project. Skills de plugin são namespaced e não conflitam.

### Live reload e descoberta contextual

[Oficial] O runtime observa diretórios de skill e consegue detectar mudanças em sessão. Além disso, skills podem ser descobertas em diretórios pais e diretórios aninhados sob demanda, o que é útil em monorepos.

## 5. Binding de parâmetros

[Oficial] Binding é baseado em substituição textual:

- `$ARGUMENTS`
- `$ARGUMENTS[N]`
- `$0`, `$1`, ...
- `$name` para argumentos nomeados

### Leitura arquitetural importante

[Oficial + lacuna] Skills não expõem um sistema nativo de schema forte de entrada e saída comparável a JSON Schema do Structured Output do SDK. O binding nativo é leve, baseado em placeholders, e a validação tende a ser:

- prompt-level
- mediada por tools
- reforçada por hooks
- ou delegada a MCP/API externas

Isso é suficiente para workflows de engenharia, mas não deve ser confundido com contrato rígido de API.

## 6. Injeção dinâmica de contexto

[Oficial] O padrão `` !`comando` `` ou blocos ` ```! ` executa shell antes de a skill ser entregue ao modelo, substituindo o placeholder pela saída real.

Esse mecanismo é muito poderoso para:

- carregar `git diff`
- buscar contexto de PR com `gh`
- coletar status de ambiente
- montar prompts baseados em dados frescos

### Risco e governança

[Oficial] Esse recurso pode ser desabilitado por política via `disableSkillShellExecution`. Em ambiente corporativo, essa decisão é importante.

## 7. Controle de invocação

## 7.1 Modelo versus usuário

[Oficial] Duas chaves definem o comportamento:

- `disable-model-invocation: true`
- `user-invocable: false`

### Matriz de comportamento

| Configuração | Usuário invoca | Modelo invoca | Custo base de contexto |
| --- | --- | --- | --- |
| default | sim | sim | descrição sempre listada |
| `disable-model-invocation: true` | sim | não | zero até invocação manual |
| `user-invocable: false` | não | sim | descrição listada |

## 7.2 `skillOverrides`

[Oficial] Settings locais podem colapsar ou esconder skills sem editar o `SKILL.md`, com estados `on`, `name-only`, `user-invocable-only` e `off`.

## 8. Ciclo de vida do conteúdo da skill

[Oficial] Quando uma skill é invocada, o conteúdo renderizado entra na conversa e permanece durante a sessão, inclusive sob compaction, sujeito a limites de preservação.

Implicação prática:

- corpo longo demais custa caro a cada turno subsequente
- `description` ruim atrapalha triggering automático
- `SKILL.md` deve ser curto e apontar para arquivos de apoio quando necessário

## 9. Skills em subagents

[Oficial] Há duas composições oficiais importantes:

### 9.1 Skill com `context: fork`

A skill vira task prompt de um subagent específico.

### 9.2 Subagent com campo `skills`

O subagent pre-carrega skills no startup como material de domínio.

Essa composição é uma das capacidades mais valiosas do produto, porque separa:

- expertise reusable
- isolamento contextual
- orquestração de execução

## 10. Restringir acesso de Claude a skills

[Oficial] Há três camadas:

- negar `Skill` por permissions
- permitir/negar skills específicas com `Skill(name)`
- esconder skill com `disable-model-invocation`

Isso é relevante para skills com side effects, como deploy, commit, publicação e ações em sistemas externos.

## 11. Integração com APIs externas

Skill não chama API por si só. Ela orienta Claude a usar:

- MCP servers
- Bash/PowerShell
- WebFetch
- scripts embutidos

Padrão recomendado:

- skill ensina semântica e workflow
- MCP ou script realiza chamada externa
- hook impõe guardrails quando necessário

## 12. Idempotência e tratamento de erro

Claude Code não fornece uma camada nativa de idempotência automática para skills. Em produção, trate isso explicitamente no desenho da skill:

- peça checagens de estado antes da ação
- prefira comandos e APIs idempotentes
- use `disable-model-invocation: true` em skills com side effect
- complemente com hooks ou validações externas

Para tratamento de erro:

- instrua a skill a validar precondições
- encapsule pontos frágeis em MCP ou scripts que retornem erros claros
- use subagent `context: fork` quando a execução puder gerar muito ruído

## 13. Plugins: camada de empacotamento

[Oficial] Plugins são a unidade de distribuição de extensibilidade no Claude Code. Eles podem empacotar:

- skills
- agents
- hooks
- `.mcp.json`
- `.lsp.json`
- monitors
- executáveis em `bin/`
- defaults em `settings.json`

### 13.1 Quando usar plugin versus `.claude/`

| Abordagem | Melhor para |
| --- | --- |
| `.claude/` do projeto | customização local, rápida, repo-specific |
| plugin | compartilhamento, versionamento, distribuição, marketplaces |

### 13.2 Estrutura básica

```text
my-plugin/
├── .claude-plugin/plugin.json
├── skills/
├── agents/
├── hooks/
├── .mcp.json
├── .lsp.json
├── monitors/
└── bin/
```

### 13.3 Namespacing

[Oficial] Skills e agentes de plugin são namespaced, como `/my-plugin:hello`, o que reduz conflitos entre extensões.

### 13.4 Marketplaces

[Oficial] Claude Code suporta marketplaces de plugin, inclusive privados, com políticas de allowlist/blocklist e restrição managed.

### 13.5 Dependências entre plugins

[Oficial] Há enforcement recente de dependências transitivas, o que mostra maturidade crescente da camada de plugin como sistema de distribuição real, não apenas pasta de arquivos.

## 14. Padrões avançados recomendados

### 14.1 Skill de conhecimento + MCP de ação

O clássico padrão de produção.

### 14.2 Skill task-oriented em `context: fork`

Ideal para workflows pesados como PR review, summarization e auditoria.

### 14.3 Plugin corporativo

Empacote skill, hook, MCP e LSP em unidade única para padronizar engenharia interna.

### 14.4 Skill como interface humana estável

Use `/deploy`, `/release`, `/audit` como comandos semânticos estáveis enquanto a implementação por trás evolui.

## 15. Anti-patterns

- skill enorme usada como dumping ground de documentação
- descrições vagas que fazem o modelo invocar a skill errada
- side effects sem `disable-model-invocation`
- usar skill para enforcement que deveria viver em hook ou policy
- transformar cada regra local em plugin cedo demais
- depender de validação implícita do modelo para workflows críticos

## 16. Leitura prática

Se você precisa de conhecimento ou workflow reutilizável, comece por skill.

Se precisa distribuir isso com reuso, versionamento e componentes múltiplos, suba para plugin.

Se precisa acesso externo, acople skill a MCP.

Se precisa garantia forte, complemente com hook.