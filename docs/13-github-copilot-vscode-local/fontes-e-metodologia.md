# Fontes e metodologia

Este arquivo documenta o que foi realmente coletado, como as cotas foram contadas e quais limites afetam o nível de confiança das recomendações.

## 1. Regras de evidência

- `Oficial`: documentação do VS Code ou do GitHub Copilot publicada pelos repositórios oficiais `microsoft/vscode-docs` e `github/docs`.
- `Comunitário verificável`: repositório público, caminho ou artefato observável por busca pública.
- `Medium verificável`: post com data confirmada por feed RSS do Medium e corte `>= 2026-04-01`.
- `Inferência`: leitura arquitetural derivada de múltiplas fontes ou de combinações entre documentação e artefato.
- `Hipótese`: possibilidade plausível não sustentada o suficiente para recomendação forte.

Regra de precedência usada:

1. documentação oficial do VS Code e GitHub Copilot
2. documentação oficial complementar e referências de policy/modelos
3. repositórios públicos e templates
4. artigos do Medium e sinais comunitários narrativos

## 2. Contagens reais atingidas

### 2.1 Documentação técnica oficial

- arquivos candidatos varridos: 546
- fontes utilizáveis: 270
- fontes diretas: 90
- fontes contextuais relevantes: 180
- falhas de fetch: 276

Observação metodológica:

- a cota de documentação técnica foi contada apenas sobre as fontes carregadas com sucesso (`usableCount`)
- falhas de fetch não foram contabilizadas como cobertura válida

Coleta reproduzível:

- script: [scripts/collect-copilot-vscode-official-sources.ps1](../../scripts/collect-copilot-vscode-official-sources.ps1)
- manifesto gerado neste workspace: [research/official-sources.json](./research/official-sources.json)

### 2.2 Medium com data verificável `>= 2026-04-01`

- posts verificados após o corte: 75
- posts diretos: 37
- posts adjacentes: 38
- datas não verificadas: 0
- falhas de query: 0

Coleta reproduzível:

- script: [scripts/collect-copilot-vscode-medium-sources.ps1](../../scripts/collect-copilot-vscode-medium-sources.ps1)
- manifesto gerado neste workspace: [research/medium-manifest.json](./research/medium-manifest.json)

### 2.3 Comunidade e artefatos públicos

- consultas públicas ao GitHub code search executadas: 9
- soma bruta de matches retornados pelas consultas: 73.743
- artefatos `repo/path` visíveis nas primeiras páginas dessas consultas: pelo menos 230
- padrões comunitários analisados em detalhe neste módulo: 60

Importante:

- o número de 230 refere-se aos artefatos visíveis nas primeiras páginas coletadas das consultas, não ao universo total deduplicado dos 73.743 matches
- as recomendações fortes foram ancoradas nos 60 padrões explicitamente analisados em [padroes-comunitarios.md](./padroes-comunitarios.md)

## 3. Shortlist oficial de alta prioridade

As páginas abaixo são as mais estruturantes para arquitetura local, configuração, governança e operação no VS Code.

### 3.1 VS Code Docs

1. `Customize AI in Visual Studio Code`
2. `Using agents in Visual Studio Code`
3. `Planning with agents in VS Code`
4. `Subagents in Visual Studio Code`
5. `Memory in VS Code agents`
6. `Use tools with agents`
7. `Custom agents in VS Code`
8. `Use custom instructions in VS Code`
9. `Use prompt files in VS Code`
10. `Use Agent Skills in VS Code`
11. `Agent hooks in Visual Studio Code (Preview)`
12. `Add and manage MCP servers in VS Code`
13. `MCP configuration reference`
14. `AI language models in VS Code`
15. `Core concepts`

### 3.2 GitHub Docs

1. `About customizing GitHub Copilot responses`
2. `Adding repository custom instructions for GitHub Copilot in your IDE`
3. `Adding organization custom instructions for GitHub Copilot`
4. `About hooks for GitHub Copilot`
5. `About Model Context Protocol (MCP)`
6. `Managing and curating Copilot Memory`
7. `About custom agents`
8. `Enhancing GitHub Copilot agent mode with MCP`
9. `Research, plan, and iterate on code changes with GitHub Copilot cloud agent`
10. `About agent management`
11. `Agent management for enterprises`
12. `Comparing GitHub Copilot CLI customization features`
13. `About plugins for GitHub Copilot CLI`
14. `About remote control of GitHub Copilot CLI sessions`
15. `About GitHub Copilot code review`

## 4. Query log comunitário usado nesta análise

| Label | Query | Total count observado | Uso na análise |
| --- | --- | --- | --- |
| `copilot-instructions` | `filename:copilot-instructions.md path:.github NOT is:fork` | 51.936 | baseline de política compartilhada |
| `instructions` | `path:.github/instructions ".instructions.md" NOT is:fork` | 4.792 | roteamento contextual e scoping por stack |
| `prompts` | `path:.github/prompts ".prompt.md" NOT is:fork` | 2.616 | tarefas reutilizáveis sob demanda |
| `chatmodes` | `path:.github/chatmodes ".chatmode.md" NOT is:fork` | 167 | legado comunitário e padrões de migração |
| `mcp` | `filename:mcp.json path:.vscode NOT is:fork` | 3.896 | integração externa e blast radius |
| `agents` | `path:.github/agents ".agent.md" NOT is:fork` | 2.736 | novo formato oficial de agentes customizados |
| `skills` | `path:.github/skills "SKILL.md" NOT is:fork` | 4.276 | capabilities portáveis e kits reutilizáveis |
| `hooks` | `path:.github/hooks ".json" NOT is:fork` | 1.432 | automação determinística e guardrails |
| `agentsmd` | `filename:AGENTS.md "GitHub Copilot" NOT is:fork` | 1.892 | contexto multiagente e compatibilidade entre superfícies |

## 5. Feed set do Medium usado na coleta reproduzível

Feeds monitorados pelo script:

- `tag:github-copilot`
- `tag:visual-studio-code`
- `tag:vscode`
- `tag:github`
- `tag:model-context-protocol`
- `tag:mcp-server`
- `tag:agentic-ai`
- `tag:ai-agent`
- `tag:ai-agents`
- `tag:developer-tools`

Classificação usada:

- `direct`: menção explícita a GitHub Copilot, Copilot Chat, VS Code, prompt files, instruction files, custom agents, agent mode, plan mode, MCP ou subagents
- `adjacent`: agentic workflows, MCP, developer tools ou AI agents sem foco direto no Copilot local

## 6. Conflitos e como foram resolvidos

### 6.1 `chatmode` versus `agent`

Conflito:

- a comunidade ainda publica muitos `*.chatmode.md`
- a documentação oficial atual orienta migrar para `*.agent.md`

Decisão:

- para setups novos, a recomendação segue a documentação oficial e usa `.agent.md`
- `chatmodes` permanecem na análise comunitária como evidência histórica e operacional, não como target default

### 6.2 “Implement agent” como primitive separada

Conflito:

- a comunidade usa `implementer` com frequência
- o corpus oficial coletado documenta com clareza o Plan agent, subagents e custom agents, mas não uma primitive separada chamada “Implement agent”

Decisão:

- tratar `implementer` como pattern de custom agent e não como garantia de produto
- reduzir o nível de confiança dessa parte nas recomendações

### 6.3 AGENTS.md

Conflito:

- a documentação de instructions menciona `AGENTS.md` para workspaces com múltiplos AI agents
- a arquitetura oficial do Copilot local continua centrada em `.github/`, perfil e settings específicos

Decisão:

- `AGENTS.md` entra como complemento de contexto e compatibilidade cross-agent
- não substitui instructions, prompt files, agents, skills, hooks ou MCP

## 7. Limitações desta pesquisa

1. Parte do corpus oficial de `github/docs` é mais ampla do que o uso local no VS Code; esse material foi usado como contexto comparativo, não como substituto da documentação de editor.
2. A busca comunitária por GitHub code search foi amostrada pelas primeiras páginas de resultados de cada query; isso é suficiente para padrões, não para estatística exaustiva de adoção global.
3. Alguns padrões comunitários foram inferidos a partir do caminho e do nome do artefato, não de leitura integral do conteúdo do arquivo; esses casos foram explicitamente marcados como `Inferência` na análise.
4. Hooks no VS Code continuam em `Preview`; recomendações de rollout precisam considerar esse nível de maturidade.

## 8. Como reler este módulo com rigor

- use [README.md](./README.md) para arquitetura e tradeoffs
- use [padroes-comunitarios.md](./padroes-comunitarios.md) para exemplos públicos e convergências reais
- use [playbook-operacional.md](./playbook-operacional.md) para implementação prática em time
- use os manifestos JSON em `research/` quando quiser auditar a coleta ou expandir a amostra
