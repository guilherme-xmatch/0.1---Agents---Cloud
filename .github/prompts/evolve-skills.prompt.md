---
description: Audit, research, and evolve the repository skill catalog using local errors, official updates, community signals, and new concepts relevant to GitHub Copilot local workflows in VS Code.
model: Auto
tools: ['search/codebase', 'search/usages', 'web/fetch', 'edit', 'runSubagent', 'agent']
---

# Evoluir skills com erros, pesquisa e atualizacoes

Voce esta executando um workflow de manutencao avancada para a biblioteca de skills deste repositorio.

Seu objetivo nao e apenas corrigir texto. Seu objetivo e manter as skills tecnicamente atuais, coerentes com o produto, consistentes entre si e sustentadas por evidencia suficiente.

## Missao principal

Melhore as skills do repositorio para que elas:

- aprendam com erros observados em uso, validacao, manutencao ou feedback do usuario
- detectem desatualizacoes causadas por mudancas em docs oficiais, release notes, referencias ou comportamento observavel do produto
- pesquisem novos conceitos na internet quando o catalogo atual nao for suficiente
- atualizem `SKILL.md`, `references/`, `checklists/` e `templates/` apenas onde houver ganho real
- mantenham rigor de evidencia, clareza de fronteira e governanca local

## Escopo padrao

Comece por estes alvos, salvo se o usuario restringir o escopo:

- `.github/skills/`
- `.github/agents/`
- `.github/prompts/`
- `.github/instructions/`
- `.github/copilot-instructions.md`
- `.vscode/mcp.json`
- `docs/13-github-copilot-vscode-local/`

## Ordem obrigatoria de trabalho

1. Audite primeiro o contexto local.
2. Descubra erros, lacunas, conflitos, naming ruim, drift, claims sem evidencia, links quebrados, exemplos fracos e configuracoes arriscadas.
3. So depois expanda para pesquisa externa.
4. Priorize documentacao oficial, release notes, referencias tecnicas e especificacoes.
5. Consulte comunidade e posts apenas depois da passada oficial.
6. Atualize somente o que tiver justificativa clara.
7. Valide o resultado apos editar.

## Loop de aprendizagem por erro

Para cada erro, falha ou sinal fraco encontrado:

1. Capture o sintoma.
2. Identifique a causa raiz.
3. Classifique o tipo de problema:
   - erro factual
   - drift de produto
   - nomenclatura antiga
   - configuracao insegura
   - escopo ruim da skill
   - ausencia de evidencia
   - checklist insuficiente
   - template desatualizado
   - conflito entre oficial e comunidade
4. Escolha a menor correcao capaz de evitar recorrencia.
5. Registre a correcao no lugar certo:
   - `SKILL.md` quando o conhecimento precisa entrar no contrato da skill
   - `references/` quando falta base de consulta curta
   - `checklists/` quando falta gate operacional ou validacao
   - `templates/` quando o problema e repeticao de estrutura ou boilerplate
6. Se a confianca continuar baixa, diga isso explicitamente em vez de esconder a lacuna.

## Loop de atualizacao por pesquisa

Quando suspeitar que o produto mudou, ou quando o catalogo nao souber lidar com um conceito novo:

1. Pesquise primeiro documentacao oficial do VS Code e do GitHub Copilot.
2. Verifique release notes, changelogs, referencias de settings, MCP e modelos quando o tema tocar runtime, tools, memoria, approvals, hooks ou agentes.
3. Use a web para buscar novos conceitos, naming atual, mudancas recentes e exemplos praticos relevantes.
4. So depois consulte padroes comunitarios para ver como a adocao esta acontecendo na pratica.
5. Nunca promova um termo comunitario a primitive oficial sem confirmacao.

## Regras fortes de evidencia

- Diferencie `Verificado`, `Inferencia` e `Hipotese`.
- Documentacao oficial prevalece sobre templates, repositorios e artigos.
- Nao invente fonte, data, versao, nome de recurso ou comportamento do produto.
- Se a evidencia nao fechar, reduza o nivel de confianca da recomendacao.
- Se uma afirmacao critica depender de fonte unica, marque o risco.

## Regras fortes de arquitetura

- Nao use um unico skill para concentrar tudo se a separacao por dominio melhorar manutencao.
- Nao introduza `.chatmode.md` novo; use `.agent.md`.
- Nao trate `implement agent` como primitive oficial sem evidencia atual.
- Nao confunda prompt file com policy persistente.
- Nao aprofunde o primeiro nivel das superficies de runtime alem do formato canônico; concentre profundidade em docs, `README.md` e subpastas internas das skills.
- Nao use memoria como substituto de artefato auditavel do repo.
- Nao deixe hooks, MCP ou tool surfaces mais amplos do que o necessario.

## Regras fortes de seguranca e governanca

- Segredos nao entram em skill, prompt file, instruction file, hook versionado ou `.vscode/mcp.json` compartilhado.
- Se existir MCP, prefira `inputs` a hardcode.
- Se houver integracao sensivel, proponha read-only first.
- Se houver automacao deterministica, prefira checklist e hook curto em vez de texto vago.
- Se a skill recomendar autonomia alta, ela precisa descrever blast radius, aprovacao e rollback.

## Como usar subagents neste workflow

Se o escopo for grande, use fan-out com subagents em trilhas separadas:

- trilha 1: auditoria local e inventario dos artefatos existentes
- trilha 2: documentacao oficial e release notes
- trilha 3: comunidade, repositorios publicos e sinais de naming/adocao

Depois reconcilie as trilhas antes de editar.

Quando os agents especializados deste repositorio estiverem disponiveis, prefira delegar assim:

- arquitetura e fronteiras -> `copilot-vscode-arquiteto-configuracoes`
- evidencia, contagem e conflitos -> `copilot-vscode-curador-evidencias`
- criacao e endurecimento de `.agent.md` -> `copilot-vscode-engenheiro-agents`
- construcao de artefatos -> `copilot-vscode-engenheiro-customizacoes`
- runtime multiagente e handoffs -> `copilot-vscode-orquestrador-subagents`
- MCP, approvals e blast radius -> `copilot-vscode-governador-mcp`
- auditoria de setup -> `copilot-vscode-auditor-setup`
- benchmarking comunitario -> `copilot-vscode-benchmark-comunidade`
- rollout e ownership -> `copilot-vscode-planejador-rollout`

Regra de orquestracao:

- use no maximo 2 ou 3 especialistas por rodada
- sempre reconcilie os outputs antes de editar
- se houver conflito entre especialistas, faca prevalecer evidencia oficial e contexto local observavel

## Heuristicas de profundidade

Se a mudanca afetar conceitos nucleares, aprofunde em:

- isolamento de contexto
- restricao de ferramentas
- handoffs
- hooks
- MCP
- approvals
- memoria
- observabilidade
- manutencao e rollback

Se a mudanca for pequena, faca a menor atualizacao que aumente a precisao e a reutilizacao da skill.

## Entregaveis obrigatorios desta execucao

Ao concluir, informe sempre:

1. quais erros, lacunas ou desatualizacoes foram encontrados
2. quais pesquisas externas foram realmente necessarias
3. quais skills ou arquivos auxiliares foram atualizados
4. qual foi o nivel de confianca das mudancas
5. quais pontos continuam em aberto

## Checklist de validacao antes de encerrar

1. `name` do `SKILL.md` bate com a pasta.
2. links relativos continuam validos.
3. a skill atualizada continua autoexplicativa sem depender do dossie inteiro.
4. qualquer claim forte novo esta ancorado em evidencia suficiente.
5. a mudanca melhorou o catalogo sem expandir desnecessariamente o blast radius.

## Base local de referencia

- [Catalogo de skills](../skills/README.md)
- [Dossie principal](../../docs/13-github-copilot-vscode-local/README.md)
- [Fontes e metodologia](../../docs/13-github-copilot-vscode-local/fontes-e-metodologia.md)
- [Padroes comunitarios](../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
- [Playbook operacional](../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [Topologia de runtime e pastas](../../docs/13-github-copilot-vscode-local/topologia-de-runtime-e-pastas.md)
- [Fleet de agents e handoffs](../../docs/13-github-copilot-vscode-local/fleet-de-agents-e-handoffs.md)
- [MCP local do workspace](../../.vscode/mcp.json)

## Modo de resposta esperado

Se o usuario pedir apenas diagnostico, entregue analise e propostas.

Se o usuario pedir evolucao real do catalogo, faca o inventario, pesquise, atualize os arquivos necessarios e valide tudo no fim.