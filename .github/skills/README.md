# Biblioteca de skills do GitHub Copilot no VS Code

Esta pasta transforma a pesquisa do repositorio em uma biblioteca de skills especialista em configuracoes do GitHub Copilot no VS Code.

Restricao estrutural importante:

- a descoberta oficial de skills espera o formato `.github/skills/<nome-da-skill>/SKILL.md`
- por isso, o primeiro nivel continua plano e composto apenas por skills reais
- a elaboracao fica dentro de cada skill, com subpastas como `references/`, `checklists/`, `templates/`, `patterns/`, `examples/` e `troubleshooting/`

## Arquitetura da biblioteca

```text
.github/skills/
├── README.md
├── copilot-vscode-fontes-e-evidencias/
│   ├── SKILL.md
│   ├── references/
│   └── checklists/
├── copilot-vscode-arquitetura-local/
│   ├── SKILL.md
│   ├── references/
│   └── checklists/
├── copilot-vscode-engenharia-agents/
│   ├── SKILL.md
│   ├── references/
│   ├── checklists/
│   ├── patterns/
│   ├── templates/
│   ├── examples/
│   └── troubleshooting/
├── copilot-vscode-construtor-customizacoes/
│   ├── SKILL.md
│   ├── references/
│   └── templates/
├── copilot-vscode-orquestracao-subagents/
│   ├── SKILL.md
│   ├── patterns/
│   └── checklists/
├── copilot-vscode-mcp-governanca/
│   ├── SKILL.md
│   ├── references/
│   ├── checklists/
│   └── templates/
├── copilot-vscode-auditoria-setup/
│   ├── SKILL.md
│   ├── checklists/
│   └── templates/
├── copilot-vscode-padroes-comunidade/
│   ├── SKILL.md
│   └── references/
└── copilot-vscode-playbook-rollout/
	├── SKILL.md
	├── references/
	├── checklists/
	└── templates/
```

## Dominios

### 1. Fundamentos e evidencia

- [copilot-vscode-fontes-e-evidencias](./copilot-vscode-fontes-e-evidencias/SKILL.md)
- [copilot-vscode-arquitetura-local](./copilot-vscode-arquitetura-local/SKILL.md)

### 2. Construcao e operacao

- [copilot-vscode-engenharia-agents](./copilot-vscode-engenharia-agents/SKILL.md)
- [copilot-vscode-construtor-customizacoes](./copilot-vscode-construtor-customizacoes/SKILL.md)
- [copilot-vscode-orquestracao-subagents](./copilot-vscode-orquestracao-subagents/SKILL.md)
- [copilot-vscode-mcp-governanca](./copilot-vscode-mcp-governanca/SKILL.md)

### 3. Qualidade e evolucao

- [copilot-vscode-auditoria-setup](./copilot-vscode-auditoria-setup/SKILL.md)
- [copilot-vscode-padroes-comunidade](./copilot-vscode-padroes-comunidade/SKILL.md)
- [copilot-vscode-playbook-rollout](./copilot-vscode-playbook-rollout/SKILL.md)

## Convencoes internas

- `SKILL.md`: contrato principal da skill, com `name` igual ao nome da pasta
- `references/`: material de consulta curta e decisao
- `checklists/`: listas operacionais e gates de validacao
- `templates/`: esqueletos de artefatos para copiar e adaptar
- `patterns/`: fluxos, sequencias e handoffs recorrentes
- `examples/`: casos canonicos e comparacoes curtas antes/depois
- `troubleshooting/`: falhas recorrentes e correcoes sem reabrir toda a arquitetura

## Regras de manutencao

1. toda skill precisa continuar autoexplicativa sem depender de ler o dossie inteiro
2. templates nao devem virar artefatos ativos do runtime; por isso usam extensoes `.template.*` ou `.sample.*`
3. qualquer contagem ou conclusao forte deve continuar coerente com o dossie em `docs/13-github-copilot-vscode-local/`
4. quando houver conflito entre comunidade e oficial, a skill deve seguir a documentacao oficial

## Base principal de referencia

- [Dossie principal](../../docs/13-github-copilot-vscode-local/README.md)
- [Fontes e metodologia](../../docs/13-github-copilot-vscode-local/fontes-e-metodologia.md)
- [Padroes comunitarios](../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
- [Playbook operacional](../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [Topologia de runtime e pastas](../../docs/13-github-copilot-vscode-local/topologia-de-runtime-e-pastas.md)
- [Fleet de agents e handoffs](../../docs/13-github-copilot-vscode-local/fleet-de-agents-e-handoffs.md)