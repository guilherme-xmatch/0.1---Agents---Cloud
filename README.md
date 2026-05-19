# Claude Code: pesquisa técnica e arquitetura

Este repositório consolida uma pesquisa técnica aprofundada sobre o Claude Code, com foco em arquitetura, operação, extensibilidade, segurança, custo, confiabilidade e padrões agentic de produção no ecossistema Anthropic.

O material foi escrito para engenheiros Pleno/Sênior, Staff+ e arquitetos que precisam decidir quando usar Claude Code como CLI local, superfície de IDE, agente cloud, plataforma de automação, mecanismo de delegação ou camada extensível para workflows internos.

## Escopo e recorte

Esta documentação usa o Claude Code como eixo central, mas trata o produto como parte de um sistema maior composto por:

- modelo Claude
- harness local/cloud do Claude Code
- ferramentas internas
- extensões via MCP, hooks, skills, plugins e subagents
- integrações de editor, browser, CI/CD e superfícies remotas
- controles corporativos de segurança, permissões, sandbox e observabilidade

Snapshot de pesquisa: maio de 2026.

## Convenções de evidência

Ao longo dos documentos, use a seguinte leitura implícita:

- Oficial: explicitamente documentado pela Anthropic ou pelo site oficial do MCP
- Preview/Experimental/Beta: explicitamente marcado como research preview, beta ou experimental nas fontes oficiais
- Corroborado: sustentado por múltiplas fontes técnicas confiáveis, mas não tratado como contrato estável do produto
- Inferência arquitetural: conclusão razoável derivada do comportamento documentado, não promessa formal da plataforma
- Lacuna: área em que a documentação oficial não fecha todos os detalhes operacionais

## Achados executivos

1. Claude Code não é apenas um CLI com LLM. A arquitetura oficial o posiciona como um harness agentic em torno do modelo, com gestão de contexto, ferramentas, checkpoints, permissões, compaction e múltiplas superfícies de execução.
2. A camada de extensibilidade é significativamente maior do que o discurso comum de mercado sugere. Além de Skills, Hooks, MCP e Subagents, o produto já expõe plugins, marketplaces, agent view, agent teams, routines, channels, monitor, worktrees e code intelligence por plugins.
3. Contexto e permissão são mecanismos arquiteturais de primeira classe. Quase todas as decisões de custo, qualidade, confiabilidade e segurança convergem para contexto, tool routing, approval policy e isolamento.
4. A superfície disponível depende fortemente de plano, provider e ambiente. Recursos como Routines, Channels, Remote Control, Claude Code on the web e algumas integrações Anthropic-first não são equivalentes entre Anthropic, Bedrock, Vertex e Foundry.
5. Para ambientes corporativos, Claude Code já possui controles maduros de rollout e governança: managed settings, allow/deny de MCP, restrição de hooks, sandbox, política de marketplaces, OpenTelemetry e enforcement por MDM/registry/file/server-managed settings.

## Cobertura da pesquisa

- Documentação técnica oficial capturada e consolidada: 93 páginas
- Fontes comunitárias no Medium verificadas com data posterior ou igual a 2026-04-01: 84 posts
- Posts do Medium com foco direto em Claude Code: 17
- Posts do Medium adjacentes ao ecossistema Anthropic, MCP e workflows agentic: 67
- Dossiê comparativo adicional com 20 páginas/sites públicos, 20 páginas de documentação e 20 artefatos de configuração comunitária: [docs/11-analise-externa-e-configs-comunitarias/README.md](./docs/11-analise-externa-e-configs-comunitarias/README.md)

Dossiê adicional sobre GitHub Copilot local no VS Code:

- pesquisa avançada sobre custom agents, subagents, prompt files, instructions, skills, hooks, MCP, memória, permissões e playbook operacional: [docs/13-github-copilot-vscode-local/README.md](./docs/13-github-copilot-vscode-local/README.md)

Observação importante: o volume comunitário direto sobre Claude Code ainda é menor que o volume oficial e que o volume adjacente sobre MCP, agent skills e agentic engineering. Por isso, a documentação abaixo trata fontes comunitárias como complementares, não como base contratual.

## Metodologia

1. Mapeamento oficial via índice do produto em https://code.claude.com/docs/llms.txt.
2. Leitura concentrada de páginas nucleares de arquitetura, configuração, MCP, subagents, hooks, skills, plugins, custos, settings, permissions, monitoring e superfícies de uso.
3. Cruzamento com changelog e weekly digests de março a maio de 2026 para identificar recursos recentes e maturidade de recursos.
4. Amostragem comunitária via feeds do Medium, com corte temporal explícito e classificação entre foco direto e adjacente. O script reproduzível está em [scripts/collect-medium-sources.ps1](./scripts/collect-medium-sources.ps1).

## Índice modular

- [Arquitetura central](./docs/01-arquitetura-central/README.md)
- [Instalação, setup e operação](./docs/02-instalacao-operacao/README.md)
- [MCP e ecossistema de ferramentas](./docs/03-mcp/README.md)
- [Funcionalidades, comandos e superfícies](./docs/04-funcionalidades/README.md)
- [Subagents](./docs/05-subagents/README.md)
- [Hooks](./docs/06-hooks/README.md)
- [Skills, plugins e extensibilidade](./docs/07-skills-e-plugins/README.md)
- [Performance, custo e confiabilidade](./docs/08-performance-custo/README.md)
- [Padrões arquiteturais e casos reais](./docs/09-padroes-e-casos/README.md)
- [Insights, lacunas e mapa de fontes](./docs/10-insights-e-fontes/README.md)
- [Análise externa e configurações comunitárias](./docs/11-analise-externa-e-configs-comunitarias/README.md)
- [Orquestração avançada de agentes](./docs/12-orquestracao-avancada/README.md)
- [GitHub Copilot local no VS Code](./docs/13-github-copilot-vscode-local/README.md)

## Como usar esta documentação

- Comece em [Arquitetura central](./docs/01-arquitetura-central/README.md) se você precisa entender o produto como sistema.
- Vá direto para [MCP](./docs/03-mcp/README.md), [Hooks](./docs/06-hooks/README.md), [Subagents](./docs/05-subagents/README.md) e [Skills, plugins e extensibilidade](./docs/07-skills-e-plugins/README.md) se o objetivo for desenhar extensibilidade.
- Use [Funcionalidades, comandos e superfícies](./docs/04-funcionalidades/README.md) como mapa de produto.
- Use [Performance, custo e confiabilidade](./docs/08-performance-custo/README.md) e [Insights, lacunas e mapa de fontes](./docs/10-insights-e-fontes/README.md) para decisões de adoção e governança.
- Use [Análise externa e configurações comunitárias](./docs/11-analise-externa-e-configs-comunitarias/README.md) quando precisar de amostragem auditável de padrões públicos, templates, repositórios e documentação produzida pela comunidade.
- Use [Orquestração avançada de agentes](./docs/12-orquestracao-avancada/README.md) quando o foco for coordenação multiagente, automação controlada por script, lead agents, workflows em background e desenho de malhas agentic mais sofisticadas.