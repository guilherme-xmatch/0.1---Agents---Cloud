# Topologia de runtime e pastas

Este documento fecha uma ambiguidade comum em setups locais do GitHub Copilot no VS Code: onde a profundidade arquitetural deve viver e onde o runtime espera estruturas mais planas.

## 1. Regra mestra

A profundidade do sistema deve existir em:

- documentação do módulo
- `README.md` dos pacotes locais
- subpastas internas de skill como `references/`, `checklists/`, `templates/`, `patterns/` e `handoffs/`

O runtime, por outro lado, deve continuar ancorado nas superfícies oficiais e previsíveis.

## 2. Superfícies de runtime verificadas

| Superfície | Caminho principal | O que é contrato forte | Observação operacional |
| --- | --- | --- | --- |
| Instrução global | `.github/copilot-instructions.md` | arquivo único de baseline do repositório | política persistente, não workflow |
| Instruções condicionais | `.github/instructions/*.instructions.md` | arquivos `*.instructions.md` no diretório canônico | roteamento contextual por stack, pasta ou tarefa |
| Prompt files | `.github/prompts/*.prompt.md` | arquivos `*.prompt.md` no diretório canônico | melhor para tarefas sob demanda |
| Custom agents | `.github/agents/*.agent.md` | arquivos `*.agent.md` no diretório canônico | persona persistente, tools, model, handoffs |
| Skills | `.github/skills/<skill>/SKILL.md` | a pasta da skill é a unidade de descoberta | aqui a documentação oficial é mais rígida: `name` deve bater com a pasta |
| Hooks | `.github/hooks/*.json` | JSONs de hook no diretório canônico | enforcement determinístico, não guideline |
| MCP | `.vscode/mcp.json` | config compartilhado do workspace | integração externa, tools/resources/prompts |
| Memory | `/memories/`, `/memories/repo/`, `/memories/session/` | armazenamento local por escopo | continuidade, não política versionada |

## 3. Onde manter estrutura profunda

### 3.1 Skills

Skills aceitam profundidade interna sem quebrar a descoberta, porque o contrato forte é a pasta da skill e o `SKILL.md` na raiz dessa pasta.

Estrutura segura:

```text
.github/skills/copilot-vscode-orquestracao-subagents/
├── SKILL.md
├── README.md
├── references/
├── checklists/
├── patterns/
└── handoffs/
```

### 3.2 Agents

Para agents, a prática segura é manter os arquivos de runtime planos em `.github/agents/*.agent.md` e empurrar a profundidade para documentação lateral.

Estrutura recomendada:

```text
.github/agents/
├── README.md
├── copilot-vscode-arquiteto-configuracoes.agent.md
├── copilot-vscode-curador-evidencias.agent.md
├── copilot-vscode-engenheiro-customizacoes.agent.md
├── copilot-vscode-orquestrador-subagents.agent.md
├── copilot-vscode-governador-mcp.agent.md
├── copilot-vscode-auditor-setup.agent.md
├── copilot-vscode-benchmark-comunidade.agent.md
└── copilot-vscode-planejador-rollout.agent.md
```

Leitura importante:

- manter flat aqui é uma recomendação de alta confiança para previsibilidade do runtime local
- a profundidade sobre fleet, handoffs e envelopes de tools fica melhor em `README.md` e no dossiê do módulo

### 3.3 Prompt files e instructions

Para prompts e instructions, a prática segura segue a mesma linha:

- arquivos de runtime ficam nos diretórios canônicos
- catálogos, convenções e diagramas ficam em `README.md` ou no módulo `docs/13-github-copilot-vscode-local`

## 4. Onde handoffs devem morar

`handoff` não é uma superfície de arquivo independente do produto. Ele deve ser representado em camadas diferentes conforme o objetivo.

| Lugar | Papel correto |
| --- | --- |
| `*.agent.md` | declarar papel, fronteira, tools e links para contratos de saída |
| `skills/.../patterns/` | fluxo reutilizável multiagente |
| `skills/.../handoffs/` | contrato de entrada e saída entre papéis |
| `docs/13-github-copilot-vscode-local/` | visão canônica e auditável da topologia |
| prompt file | ponto de entrada de um workflow de orquestração |

Não use:

- hooks para expressar handoffs lógicos
- memory como substituto de contrato explícito entre papéis
- `AGENTS.md` como se fosse a única camada de handoff do sistema

## 5. O que não aprofundar no runtime

1. Não crie `.github/skills/<categoria>/<skill>/SKILL.md` como estrutura primária; isso enfraquece a descoberta oficial da skill.
2. Não trate subagent como diretório de runtime próprio. Subagent é modo de execução e de orquestração, não um primitive de filesystem.
3. Não multiplique diretórios só para “organizar melhor” se isso deslocar o arquivo principal para fora do local canônico.
4. Não esconda política operacional em templates ou checklists; o contrato principal da skill ou do agent precisa continuar autoexplicativo.

## 6. Topologia-alvo recomendada para este repositório

```text
.github/
├── copilot-instructions.md
├── AGENTS.md
├── instructions/
│   └── *.instructions.md
├── prompts/
│   ├── README.md
│   └── *.prompt.md
├── agents/
│   ├── README.md
│   └── *.agent.md
├── hooks/
│   ├── README.md
│   └── *.json
└── skills/
    ├── README.md
    └── <skill>/
        ├── SKILL.md
        ├── README.md
        ├── references/
        ├── checklists/
        ├── templates/
        ├── patterns/
        └── handoffs/

.vscode/
└── mcp.json

docs/13-github-copilot-vscode-local/
├── README.md
├── fontes-e-metodologia.md
├── padroes-comunitarios.md
├── playbook-operacional.md
├── topologia-de-runtime-e-pastas.md
└── fleet-de-agents-e-handoffs.md
```

## 7. Espelho em nível de perfil do usuário

Quando o caso for pessoal e não de repositório, o espelho conceitual é:

- `~/.copilot/agents`
- `~/.copilot/instructions`
- `~/.copilot/skills/<skill>/SKILL.md`
- `mcp.json` do perfil
- `/memories/`

Recomendação prática:

- aquilo que é padrão compartilhado vai para o repositório
- aquilo que é preferência individual ou toolkit pessoal vai para o perfil

## 8. Nível de confiança

- `Alta confiança`: manter skills em `.github/skills/<skill>/SKILL.md`, manter runtime ancorado nas superfícies canônicas e empurrar profundidade para subpastas internas de skill e documentação lateral
- `Confiança média-alta`: manter agents, prompts, instructions e hooks em diretórios planos para previsibilidade operacional do setup local
- `Risco conhecido`: tentar usar profundidade hierárquica no primeiro nível de descoberta das superfícies pode tornar o catálogo mais bonito e o runtime menos previsível
