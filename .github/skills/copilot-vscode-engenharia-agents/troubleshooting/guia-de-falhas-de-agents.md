# Guia de falhas de agents

## 1. O agent nao e descoberto

Causas provaveis:

- `description` vaga
- nome do arquivo sem dominio ou papel claro
- overlap com um agent que ja existe

Correcao minima:

1. reescreva a `description` com problema, contexto local e tipo de saida
2. revise o nome do arquivo para `<dominio>-<papel>.agent.md`
3. passe pelo checklist de ownership antes de criar mais runtime

## 2. A tool surface ficou ampla demais

Causas provaveis:

- tentativa de ganhar conveniencia cedo demais
- mistura de papel read-only com execucao ou materializacao

Correcao minima:

1. volte para `read` e `search` como default
2. adicione `edit`, `web`, `agent` ou `todo` so com justificativa
3. se ainda assim ficar grande, quebre o papel em dois agents

## 3. O handoff ficou fraco ou virou loop

Causas provaveis:

- `agent` habilitada sem lista branca curta
- worker sem contrato de retorno
- orchestrator tentando resolver tudo sozinho

Correcao minima:

1. restrinja `agents` explicitamente
2. defina o que cada worker precisa devolver
3. faca o orchestrator consolidar em vez de competir com os workers

## 4. A skill de agents esta competindo com a skill generica

Causas provaveis:

- o problema real nao era `.agent.md`
- o desenho do agent ja estava fechado e o trabalho passou a ser so edicao de arquivos

Correcao minima:

1. se a superficie ainda nao estiver decidida, passe para a skill de arquitetura
2. se a tarefa ja for materializacao, passe para o construtor
3. mantenha esta skill como dona do desenho e nao da edicao generica

Leituras complementares:

- [Matriz de entrada e lideranca](../references/matriz-de-entrada-e-lideranca.md)
- [Checklist de blast radius](../checklists/blast-radius-de-tools.md)
- [Casos canonicos](../examples/casos-canonicos-de-agent.md)