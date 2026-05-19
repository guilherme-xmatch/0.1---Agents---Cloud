---
name: copilot-vscode-fontes-e-evidencias
description: Responde perguntas sobre GitHub Copilot local no VS Code com base auditavel no corpus deste repositorio. Use quando precisar separar fato verificado, inferencia e hipotese, comparar oficial vs comunidade, ou informar contagens reais da pesquisa.
---

# Copilot VS Code: fontes e evidencias

Use esta skill quando:

- o usuario pedir base verificavel em vez de opiniao solta
- houver disputa entre documentacao oficial e padroes da comunidade
- voce precisar informar contagens reais da pesquisa
- a resposta precisar explicitar nivel de confianca

Fluxo de trabalho:

1. Comece pelos artefatos locais de pesquisa, nao pela memoria ou por lembranca vaga.
2. Leia primeiro `../../../docs/13-github-copilot-vscode-local/fontes-e-metodologia.md`.
3. Se a pergunta depender de contagens, confirme em:
   - `../../../docs/13-github-copilot-vscode-local/research/official-sources.json`
   - `../../../docs/13-github-copilot-vscode-local/research/medium-manifest.json`
4. Se a pergunta for arquitetural, cruze com `../../../docs/13-github-copilot-vscode-local/README.md`.
5. Se a pergunta for sobre exemplos publicos ou estrategias praticas, cruze com `../../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md`.

Regras fortes:

- Sempre diferencie explicitamente `Verificado`, `Inferencia` e `Hipotese`.
- Sempre informe a contagem real atingida quando o pedido envolver volume de fontes.
- Quando houver conflito entre comunidade e oficial, a documentacao oficial prevalece.
- Se uma afirmacao critica depender de fonte unica ou de leitura parcial, marque isso como risco de confianca.
- Nao trate popularidade comunitaria como prova de qualidade tecnica.

Snapshot de referencia desta pesquisa:

- 270 fontes oficiais utilizaveis
- 75 posts do Medium com data verificavel `>= 2026-04-01`
- 60 padroes comunitarios analisados em detalhe
- pelo menos 230 artefatos `repo/path` visiveis nas consultas publicas consolidadas

Formato de saida recomendado:

1. Resposta curta.
2. Base de evidencia.
3. Conflitos ou lacunas.
4. Nivel de confianca.

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Fontes e metodologia](../../../docs/13-github-copilot-vscode-local/fontes-e-metodologia.md)
- [Padroes comunitarios](../../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
