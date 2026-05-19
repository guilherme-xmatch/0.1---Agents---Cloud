---
name: copilot-vscode-padroes-comunidade
description: Compara um setup local do GitHub Copilot no VS Code com os padroes observados na comunidade. Use quando precisar benchmarkar o repo, separar praticas maduras de hacks frageis, ou justificar uma escolha com base em convergencias publicas.
---

# Copilot VS Code: padroes da comunidade

Use esta skill quando:

- o usuario perguntar como a comunidade esta organizando Copilot localmente
- voce precisar comparar o repo atual com exemplos publicos
- for necessario identificar se um padrao e maduro, emergente ou fragil

Nao use esta skill quando:

- a pergunta exigir predominancia de evidencia oficial e contagem auditavel como saida principal
- o pedido for so escolher a arquitetura do repo sem benchmarking externo
- a tarefa for editar diretamente o catalogo sem precisarmos comparar com sinais publicos

Base desta skill:

- 60 padroes analisados em detalhe
- pelo menos 230 artefatos publicos `repo/path` visiveis nas consultas consolidadas
- soma bruta observada nas queries: 73.743 matches

Categorias fortes para comparacao:

- baseline com `.github/copilot-instructions.md`
- instructions especializadas por stack
- biblioteca de prompt files
- agentes por papel em `.github/agents/*.agent.md`
- hooks de formatacao, compilacao e bloqueio de segredos
- skills com `SKILL.md` e scripts auxiliares
- versionamento de `mcp.json`, `.sample` ou `.template`
- `AGENTS.md` como complemento cross-agent

Classificacao a aplicar:

- `Maduro / recomendo`
- `Emergente / recomendo com ressalvas`
- `Fragil / nao recomendo`

Regras fortes:

- Popularidade nao e prova de qualidade tecnica.
- Documentacao oficial vence a comunidade quando houver conflito.
- `chatmode` conta como sinal historico ou legado, nao como formato-alvo para setup novo.
- arquivos `.old`, `backup`, casing exotico como `MCP.json` e naming sem semantica entram como sinais frageis.

Formato de saida recomendado:

1. padrao observado
2. analogos publicos relevantes
3. convergencia com oficial
4. julgamento de maturidade
5. risco de copiar esse padrao sem adaptacao

Arquivo de apoio principal:

- [Padroes comunitarios](../../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
- [README local](./README.md)
- [Sinais maduros e frageis](./references/sinais-maduros-e-frageis.md)
