# Padrões arquiteturais e casos reais

Este documento traduz a superfície do Claude Code em padrões de desenho que um time consegue de fato operar em produção.

## 1. Framework de decisão

Antes de escolher o mecanismo, responda a quatro perguntas:

1. o trabalho é linear ou paralelizável?
2. a regra precisa ser determinística ou basta ser orientativa?
3. o agente precisa acessar sistema externo?
4. o contexto da tarefa deve ficar no fluxo principal ou isolado?

As respostas quase sempre apontam para a ferramenta correta.

## 2. Escolha do mecanismo por problema

| Problema | Mecanismo preferido |
| --- | --- |
| regra sempre válida | hook ou permission policy |
| convenção sempre carregada | `CLAUDE.md` ou rules |
| workflow repetido | skill |
| integração externa | MCP |
| pacote distribuível | plugin |
| pesquisa isolada | subagent |
| colaboração real entre workers | agent teams |
| automação desacoplada da máquina local | routine |
| isolamento de mudanças concorrentes | worktree |

## 3. Padrões simples

## 3.1 Fluxo linear local

Quando usar:

- bug fixes pequenos
- refactors localizados
- leitura e explicação de código

Forma:

1. pedir exploração rápida
2. aprovar plano quando necessário
3. implementar
4. validar
5. resumir

Ferramentas típicas:

- `Read`, `Grep`, `Glob`
- `Edit`, `Write`
- `Bash` ou `PowerShell`
- `/plan`, `/diff`, `/usage`

## 3.2 Skill orientada a workflow

Quando usar:

- deploy checklist
- revisão de PR
- sumarização de mudanças
- preparação de release

Padrão:

- skill curta
- `disable-model-invocation: true` se houver side effect
- scripts ou MCP para ações externas

## 4. Padrões intermediários

## 4.1 Skill + MCP

Casos:

- banco de dados
- observabilidade
- issue tracker
- design system externo

Vantagem: a skill ensina semântica e o MCP executa acesso real.

## 4.2 Hook-enforced delivery

Casos:

- lint obrigatório
- bloqueio de comandos destrutivos
- auditoria de alterações sensíveis
- compliance em repositórios regulados

Padrão:

- hook pequeno e determinístico
- enforcement em `PreToolUse` ou `PostToolUse`
- outputs curtos e acionáveis

## 4.3 Explore -> main agent -> verify

Casos:

- investigação de bug em sistema médio
- exploração de módulo desconhecido

Padrão:

1. `Explore` pesquisa
2. agente principal decide solução
3. implementação acontece na thread principal
4. validação final também fica principal

Isso reduz ruído sem criar coordenação demais.

## 5. Padrões avançados

## 5.1 Fan-out com worktrees

Casos:

- refactor em múltiplos pacotes
- migração de framework
- correções paralelas em áreas pouco acopladas

Padrão:

- decompor trabalho
- spawnar workers em worktrees
- validar em paralelo
- consolidar PRs ou branches

Ferramentas típicas:

- `/batch`
- `EnterWorktree`
- subagents em background

## 5.2 Revisão cruzada multiagente

Casos:

- security review
- performance review
- bug hunting antes de merge

Mecanismos possíveis:

- múltiplos subagents com síntese do pai
- Agent Teams quando revisores precisam dialogar entre si
- `/ultrareview` em superfícies cloud compatíveis

## 5.3 Rotina cloud reativa

Casos:

- PR review automático
- deploy verification
- backlog grooming
- triagem de alertas

Padrão:

- routine com trigger GitHub, API ou schedule
- ambiente cloud configurado com network e secrets mínimos
- conector/MCP apenas do necessário

## 5.4 Event-driven session via channels

Casos:

- CI manda status para sessão viva
- bot de chat entrega mensagens a Claude
- alertas entram direto no terminal do desenvolvedor

Esse padrão é útil quando a sessão precisa reagir a eventos, não apenas ser consultada.

## 6. Casos de uso reais por domínio

## 6.1 Refatoração

Recomendação:

- small scope: fluxo linear
- medium scope: `Explore` + principal
- large scope: `/batch` + worktrees + hooks de validação

## 6.2 Debugging

Recomendação:

- use plan mode para mapear hipótese
- subagent para logs/testes verbosos
- monitor para acompanhar processo vivo
- hook para filtrar ruído quando necessário

## 6.3 Code review

Recomendação:

- local review para PR pequeno ou contexto local
- security-review para foco em risco
- ultrareview para bug hunting profundo cloud-first

## 6.4 Integração com APIs e sistemas internos

Recomendação:

- MCP para acesso seguro e reutilizável
- skill para ensinar semântica do domínio
- hook para políticas obrigatórias

## 6.5 Documentação e onboarding

Recomendação:

- `CLAUDE.md` curto para convenções base
- skills para manuais ou checklists específicos
- `/team-onboarding` para material de onboarding reaproveitável

## 6.6 Pipelines e automação

Recomendação:

- hooks para enforcement local
- routines para automação cloud
- GitHub Actions/GitLab CI para integração formal no SDLC

## 7. Critérios de escolha entre workflow linear, hooks, skills, subagents, MCP e routines

### Use workflow linear quando

- a tarefa é curta e coesa
- o contexto da conversa ajuda mais do que atrapalha

### Use hooks quando

- algo deve ocorrer sempre
- não depende de julgamento complexo do modelo

### Use skills quando

- você precisa de conhecimento ou procedimento reutilizável
- o usuário ou o modelo deve conseguir invocar isso de forma semântica

### Use subagents quando

- o trabalho é ruidoso, paralelo ou especializado
- a thread principal só precisa do resumo

### Use MCP quando

- o agente precisa ler ou agir fora do repo/local shell

### Use plugin quando

- a combinação skill/hook/agent/MCP precisa ser distribuída

### Use routine quando

- a execução precisa continuar com laptop fechado
- o gatilho vem do tempo, de API ou de GitHub

## 8. Anti-patterns arquiteturais

- colocar tudo em `CLAUDE.md`
- usar subagent onde um hook resolveria com menos custo
- usar hook onde uma skill bastaria
- usar Agent Teams por entusiasmo, não por necessidade de coordenação real
- acoplar MCP demais sem governança de trust boundary
- desenhar automação cloud sem revisar limitações de plano/provider

## 9. Roteiro de adoção recomendada

### Fase 1

- CLI ou IDE extension
- `CLAUDE.md`
- permissões básicas
- algumas skills simples

### Fase 2

- MCP seletivo
- hooks de lint e segurança
- subagents especializados
- observabilidade básica com `/usage`

### Fase 3

- plugins internos
- worktrees e background agents
- OTel e políticas managed
- routines e fluxos cloud onde fizer sentido

## 10. Síntese

O melhor uso do Claude Code não vem de ativar tudo. Vem de compor os mecanismos certos para o tipo certo de trabalho.