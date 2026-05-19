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

Nao use esta skill quando:

- o problema principal for escolher a superficie de configuracao correta, caso em que `copilot-vscode-arquitetura-local` e mais precisa
- a tarefa for construir ou editar artefatos locais do repo
- a pergunta for so benchmarking de exemplos publicos sem necessidade de ledger ou contagem rigorosa

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

Entradas que esta skill deve fixar antes de responder:

1. a pergunta depende de data minima, volume minimo ou categoria minima de fonte?
2. a conclusao precisa distinguir observacao local, documentacao oficial e comunidade?
3. a resposta precisa de ledger completo ou so de base de evidencia resumida?

Formato de saida recomendado:

1. resposta curta
2. base de evidencia
3. conflitos e lacunas
4. nivel de confianca
5. contagem real, quando aplicavel

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
- [README local](./README.md)
- [Hierarquia de fontes](./references/hierarquia-de-fontes.md)
- [Checklist de ledger e confianca](./checklists/ledger-e-confianca.md)
