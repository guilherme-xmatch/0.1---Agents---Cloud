# Playbook operacional reutilizável

Este playbook transforma a pesquisa em um setup local sustentável para times usando GitHub Copilot no VS Code.

## 1. Princípios de desenho

1. separar política compartilhada, workflow reutilizável, persona especializada, automação determinística e integração externa
2. minimizar a superfície de ferramentas por papel
3. deixar o planejamento explícito antes da implementação em mudanças médias ou grandes
4. versionar no repositório apenas o que o time inteiro deve herdar
5. manter preferências pessoais e memória fora do pacote compartilhado
6. preferir defaults seguros e elevar autonomia só onde houver justificativa e observabilidade

## 2. Estrutura de pastas recomendada

```text
.github/
├── copilot-instructions.md
├── instructions/
│   ├── frontend.instructions.md
│   ├── backend.instructions.md
│   └── security.instructions.md
├── prompts/
│   ├── review.prompt.md
│   ├── generate-tests.prompt.md
│   └── investigate-regression.prompt.md
├── agents/
│   ├── planner.agent.md
│   ├── researcher.agent.md
│   ├── implementer.agent.md
│   ├── reviewer.agent.md
│   └── debugger.agent.md
├── skills/
│   ├── debug-ci/
│   │   ├── SKILL.md
│   │   └── checklist.md
│   └── security-review/
│       ├── SKILL.md
│       └── references.md
└── hooks/
    ├── format.json
    ├── compile-check.json
    └── block-secrets.json

.vscode/
└── mcp.json
```

## 3. O que vai em cada camada

### 3.1 `copilot-instructions.md`

Use para:

- convenções universais do repo
- estilo de resposta esperado
- padrões de arquitetura obrigatórios
- restrições editoriais permanentes

Não use para:

- fluxos procedurais longos
- regras por stack muito específicas
- automação e enforcement

### 3.2 `*.instructions.md`

Use para:

- regras condicionais por diretório, linguagem ou framework
- slices como UI, acessibilidade, testes, API design, segurança

Exemplo mínimo:

```md
---
applyTo: "src/frontend/**/*.tsx"
---

- Priorize acessibilidade semântica e testes de interação.
- Evite introduzir componentes sem estado local quando um componente puro resolver.
```

### 3.3 `*.prompt.md`

Use para:

- tarefas acionadas sob demanda
- prompts de review, geração de testes, sync, auditoria, onboarding

Exemplo mínimo:

```md
---
description: Review API changes for security and backward compatibility
model: Claude Sonnet 4
tools: ['search/codebase', 'search/usages']
---

Revise as mudanças recentes na API. Foque em compatibilidade, autenticação, autorização, exposição de dados e cobertura de testes.
```

### 3.4 `*.agent.md`

Use para:

- persona persistente especializada
- tool restrictions e modelo próprio
- papéis como planner, researcher, reviewer, debugger e implementer

Exemplo mínimo:

```md
---
name: planner
description: Generate implementation plans for features and refactors
tools: ['search/codebase', 'search/usages', 'web/fetch', 'runSubagent']
model: ['Claude Opus 4.5', 'GPT-5.2']
---

Você prioriza entendimento do problema, mapeamento de riscos, decomposição por etapas e critérios de verificação. Não comece editando código quando ainda faltarem decisões estruturais.
```

Observação importante:

- trate `implementer.agent.md` como papel customizado do time
- não o descreva internamente como se fosse primitive oficial separada do produto

### 3.5 `SKILL.md`

Use para:

- capability packs reutilizáveis
- workflows portáveis com scripts, exemplos e referências
- debug de CI, revisão de segurança, testes browser, release notes, incident response

Exemplo mínimo:

```md
---
description: Debug failing CI workflows with a repeatable checklist
---

1. Coletar log da job que falhou.
2. Identificar a primeira falha causal.
3. Classificar a falha entre infra, build, teste, lint ou dependência externa.
4. Sugerir correção mínima e revalidação.
```

### 3.6 Hooks

Use para:

- ações determinísticas de lifecycle
- formatação pós-edição
- sanity check de compilação
- bloqueio de segredos
- setup/telemetria de sessão

Não use para:

- heurística vaga que já caberia em instrução
- chamadas de rede lentas e frágeis sem fallback

### 3.7 MCP

Use para:

- ferramentas externas realmente necessárias
- recursos e prompts que agregam valor operacional concreto
- integração com browser, banco, APIs ou sistemas internos

Exemplo mínimo:

```json
{
  "inputs": [
    {
      "id": "api-token",
      "type": "promptString",
      "description": "Token do serviço externo"
    }
  ],
  "servers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@microsoft/mcp-server-playwright"]
    }
  }
}
```

## 4. Suite mínima de agentes especializados

| Agente | Missão | Tools default | O que não deveria fazer por padrão |
| --- | --- | --- | --- |
| `planner` | entender, decompor e propor verificação | search, usages, web, runSubagent | editar código |
| `researcher` | mapear contexto e alternativas | search, usages, web | editar e rodar automação externa |
| `implementer` | alterar código e validar localmente | edit, terminal, terminal last command, search | web e MCP amplos |
| `reviewer` | apontar risco, regressão e lacuna de teste | search, diff, terminal de teste | editar por default |
| `debugger` | reproduzir falhas e reduzir hipóteses | terminal, logs, search | acionar integrações externas sem necessidade |

## 5. Orquestração recomendada

### 5.1 Fluxo para feature média/grande

1. usuário chama o `Plan agent` ou o agente `planner`
2. planner gera plano, riscos e critérios de validação
3. planner usa subagents para pesquisa lateral quando necessário
4. após aprovação do plano, `implementer` executa a mudança
5. `reviewer` ou prompt de review faz a análise final
6. hooks e testes locais fecham o loop

### 5.2 Fluxo para debugging

1. `debugger` reproduz e classifica a falha
2. se a área for desconhecida, ele abre subagent `researcher`
3. se a correção ficar clara, handoff para `implementer`
4. `reviewer` valida regressão e cobertura

### 5.3 Fluxo para integração externa sensível

1. iniciar sessão com tool set mínimo
2. habilitar apenas o MCP server necessário
3. usar `Default Approvals` ou granular pre-approval por tool
4. aplicar hooks de pre-tool guard ou bloqueio de segredos
5. registrar achados em memória de repositório apenas quando forem permanentes

## 6. Rollout por maturidade

### Fase 1. Baseline seguro

- `.github/copilot-instructions.md`
- 2 ou 3 `*.instructions.md`
- 2 ou 3 prompt files de alto valor
- `Default Approvals`

Critério para avançar:

- o time consegue apontar quais tarefas repetitivas ainda dependem de prompt manual grande

### Fase 2. Especialização

- adicionar `planner`, `reviewer` e `implementer`
- começar a usar subagents para pesquisa lateral
- introduzir 1 skill de alto valor

Critério para avançar:

- o time já consegue separar planejamento, execução e revisão sem ruído excessivo

### Fase 3. Integração e enforcement

- versionar `.vscode/mcp.json` ou um `.sample/.template`
- adicionar hooks determinísticos de alto valor
- revisar `Chat: Manage Tool Approval`

Critério para avançar:

- o time consegue explicar claramente quais tools estão pré-aprovadas e por quê

### Fase 4. Governança e escala

- organization instructions quando fizer sentido
- skill catalog com README/validação
- memory governance entre `user`, `repo` e `session`
- métricas de custo, premium requests e uso de modelos

## 7. Segurança e governança

1. `Default Approvals` deve ser o padrão de time; `Bypass` e `Autopilot` são exceções justificadas.
2. Cada agent role deve ter o menor conjunto de tools possível.
3. Segredos não entram em `copilot-instructions.md`, prompt files, hooks versionados nem `mcp.json` compartilhado.
4. Prefira `inputs` no `mcp.json` para valores sensíveis.
5. Hooks precisam ser rápidos, observáveis e legíveis. Se o hook precisar de runbook próprio, ele já está complexo demais.
6. `reviewer` e `planner` não devem ter, por padrão, o mesmo blast radius do `implementer`.
7. Memória de repositório deve guardar fatos do repo, não decisões temporárias de uma tarefa.
8. `AGENTS.md` pode complementar o ecossistema, mas não substitui os mecanismos específicos do Copilot.

## 8. Observabilidade local

Use este checklist:

1. cada hook tem dono, propósito e tempo de execução conhecido
2. cada MCP server tem motivo explícito para existir no workspace
3. cada custom agent tem missão, tools e risco principal documentados
4. o time sabe onde revisar tool approvals
5. o plano da sessão pode ser encontrado em `plan.md` quando o Plan agent é usado
6. memory files são revisados periodicamente para evitar acúmulo de contexto obsoleto

## 9. Decisões rápidas

Se a pergunta for “qual mecanismo eu uso?”, use esta heurística:

- regra sempre válida do repo: `copilot-instructions.md`
- regra condicional por stack/área: `*.instructions.md`
- tarefa reutilizável sob demanda: `*.prompt.md`
- papel persistente com tools/modelo próprios: `*.agent.md`
- capacidade portável com scripts/recursos: `SKILL.md`
- automação determinística no lifecycle: hook
- integração externa: MCP
- pesquisa lateral isolada: subagent
- continuidade local entre sessões: memory

## 10. Versão mínima recomendada deste playbook

Se o time quiser começar pequeno sem criar um sistema difícil de manter, a combinação mínima é:

1. `.github/copilot-instructions.md`
2. duas `*.instructions.md`
3. três prompt files
4. `planner.agent.md` e `implementer.agent.md`
5. `reviewer` como prompt file ou agent read-only
6. um `mcp.json.sample` em vez de `mcp.json` ativo, se a confiança ainda for baixa

Esse conjunto já entrega ganho real sem exigir maturidade máxima em hooks, skills ou automação.
