# Performance, custo e confiabilidade

Este documento organiza os tradeoffs de performance e custo do Claude Code com foco em contexto, paralelismo, modelos, observabilidade e estratégias de degradação controlada.

## 1. Modelo mental de custo

Em Claude Code, custo não é apenas “qual modelo foi escolhido”. O custo efetivo se aproxima de:

$$
	ext{custo total} \propto \sum (\text{tokens de contexto} + \text{tokens de saída} + \text{tokens de thinking}) \times \text{turnos} \times \text{fator de paralelismo}
$$

[Oficial] Os principais multiplicadores são:

- tamanho de contexto por turno
- quantidade de turns agentic
- modelo e effort level
- outputs grandes de ferramentas
- número de sessões paralelas, subagents ou teammates

## 2. Principais drivers de custo

### 2.1 Contexto

[Oficial] Contexto é o principal custo estrutural. Tudo que entra no prompt recorrente pesa repetidamente:

- `CLAUDE.md`
- auto memory
- descrições de skills listadas
- tool names e schemas de MCP
- histórico de conversa
- resultados de ferramentas

### 2.2 Thinking e effort

[Oficial] Effort controla adaptive reasoning em modelos suportados. Níveis maiores aumentam custo e qualidade, mas nem sempre linearmente.

### 2.3 Paralelismo

[Oficial] Subagents, background sessions e especialmente Agent Teams ampliam throughput, mas fazem o custo crescer quase proporcionalmente ao número de contextos ativos.

### 2.4 Outputs verbosos

[Oficial] Logs, testes, diffs e resultados de MCP podem custar muito mais do que a mudança de código em si.

## 3. Modelos, effort e janela de contexto

## 3.1 Aliases e objetivos

- `haiku`: barato e rápido para tarefas leves
- `sonnet`: default prático para a maioria dos fluxos de engenharia
- `opus`: raciocínio mais forte para arquitetura e tarefas difíceis
- `opusplan`: Opus no planejamento, Sonnet na execução

## 3.2 Effort levels

[Oficial] Em geral:

- `low` e `medium`: tarefas curtas e sensíveis a latência
- `high`: mínimo razoável para tarefas de engenharia mais exigentes
- `xhigh`: default recomendado em Opus 4.7
- `max`: profundidade máxima, com risco de sobrecusto e overthinking

## 3.3 Contexto de 1M

[Oficial] Algumas combinações de modelo/plano suportam janela de 1M tokens. Isso é poderoso, mas não remove a necessidade de disciplina de contexto: apenas empurra o problema para mais longe.

## 4. Estratégias oficiais de redução de custo

## 4.1 Gerenciar contexto de forma ativa

[Oficial]

- use `/clear` entre tarefas não relacionadas
- mantenha `CLAUDE.md` enxuto
- mova material especializado para skills
- use `/compact` com instruções claras
- monitore `/context`

## 4.2 Escolher o modelo certo por trabalho

[Oficial]

- Sonnet para o dia a dia
- Opus para arquitetura difícil
- Haiku para subagents exploratórios baratos

## 4.3 Reduzir overhead de MCP

[Oficial]

- preferir CLI nativo quando resolve melhor
- desligar servidores não usados
- usar Tool Search
- limitar output de ferramentas

## 4.4 Offload de verbose operations

[Oficial] Use subagents para:

- testes longos
- processamento de logs
- fetching de documentação
- pesquisa pesada

O princípio é simples: mantenha o ruído fora do contexto principal.

## 4.5 Prompt caching

[Oficial] Claude Code usa prompt caching para reduzir custo de conteúdo repetido. Em deploys API e third-party, o TTL pode ser controlado por variáveis como `ENABLE_PROMPT_CACHING_1H` e seus overrides.

## 5. Paralelização e tradeoffs

## 5.1 Subagents

Melhor custo/benefício quando:

- a subtarefa é resumível
- o isolamento reduz leituras redundantes no contexto principal

## 5.2 Background sessions e Agent View

Boas para throughput operacional, mas exigem controle sobre permissões e model/effort defaults para não virarem gasto ocioso.

## 5.3 Agent Teams

[Oficial] Custam bem mais que sessões simples. A documentação recomenda times pequenos, Sonnet como default e prompts de spawn enxutos.

## 5.4 Worktrees

Têm custo operacional de filesystem e Git, mas evitam colisão de mudanças e retrabalho humano, o que muitas vezes reduz custo total real do fluxo.

## 6. Confiabilidade e retry

## 6.1 Retries e fallback da API

[Oficial]

- `CLAUDE_CODE_MAX_RETRIES` controla retries de request
- há streaming watchdog e caminhos de fallback
- fallback model pode ser usado em sobrecarga em certos cenários

## 6.2 MCP resiliente

[Oficial]

- reconexão automática de HTTP/SSE com backoff
- retry de conexão inicial em falhas transitórias
- list_changed para refresh dinâmico de capabilities

## 6.3 Background stall detection

[Oficial] Background subagents e sessões têm timeouts de stall configuráveis. Isso evita workers órfãos, mas pode matar trabalhos legítimos em ambientes lentos se mal configurado.

## 6.4 Auto-compaction thrashing

[Oficial] Se um artefato sozinho é grande demais, o sistema pode parar de compactar automaticamente e acusar thrashing. Isso é sintoma de desenho ruim de contexto ou de output não filtrado.

## 7. Observabilidade

## 7.1 `/usage`

[Oficial] É a primeira ferramenta de inspeção operacional para sessão atual, com custo estimado, duração e atividade.

## 7.2 OpenTelemetry

[Oficial] OTel fornece:

- métricas
- logs/eventos
- traces beta

Isso permite responder perguntas como:

- qual sessão custa mais
- quais tools mais consomem tempo
- quanto tempo ficou bloqueado em permissão
- quais hooks falham com frequência

## 7.3 Statusline

[Oficial] O status line pode expor uso de contexto, custo, git status e outros sinais operacionais em tempo real.

## 8. Recomendações por cenário

### Repositório pequeno ou médio

- Sonnet por padrão
- `CLAUDE.md` mínimo
- poucas skills altamente específicas
- MCP só para sistemas realmente necessários

### Monorepo ou codebase gigante

- Tool Search obrigatório
- worktrees e subagents para dividir exploração
- code intelligence plugins onde possível
- forte disciplina de compactação e `CLAUDE.md`

### Enterprise com governança forte

- OTel obrigatório
- controles managed de MCP e hooks
- sandbox para defesa em profundidade
- rate limits e spend limits monitorados

## 9. Sinais de arquitetura saudável

- o agente raramente precisa reread do mesmo material para se reorientar
- skills são curtas e específicas
- MCP tools têm output controlado
- subagents carregam trabalho pesado fora do contexto principal
- prompts são específicos e verificáveis
- custo por tarefa é previsível, não errático

## 10. Anti-patterns de custo e confiabilidade

- manter conversa única para assuntos desconexos por horas
- transformar `CLAUDE.md` em wiki gigante
- instalar muitos MCP servers sem Tool Search
- usar Agent Teams para tarefas lineares
- deixar hooks lentos bloqueando cada tool call
- confiar em output bruto de testes/logs sem filtragem

## 11. Resumo executivo

O caminho mais seguro para performance e custo bons no Claude Code é tratar contexto como orçamento, paralelismo como multiplicador e observabilidade como requisito de produção.