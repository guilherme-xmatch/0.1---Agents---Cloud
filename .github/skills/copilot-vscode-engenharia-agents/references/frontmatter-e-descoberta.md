# Frontmatter e descoberta

## Campos que importam

- `name`: nome visivel e estavel para o catalogo
- `description`: principal superficie de descoberta
- `tools`: menor conjunto de tools que permite cumprir a missao
- `model`: modelo coerente com o tipo de trabalho
- `agents`: lista branca de specialists permitidos quando houver delegacao

## Regras fortes

- o arquivo fica em kebab-case no formato `<dominio>-<papel>.agent.md`
- o `name` pode ser mais descritivo que o nome do arquivo, mas ambos precisam apontar para o mesmo papel
- `description` e a principal superficie de descoberta
- se o agent usa `agents`, inclua a tool `agent`
- `description` precisa dizer quando usar, em que contexto local ele opera e que tipo de saida devolve
- `tools: []` so faz sentido para agentes conversacionais ou de sintese sem leitura local
- `model` deve refletir o tipo de trabalho, nao apenas a preferencia pessoal
- nao adicione tools extras so por conveniencia
- nao introduza campos de frontmatter que nao estejam verificados no catalogo local

## Gatilhos bons de descricao

- mencione o problema, a superficie e o tipo de output
- inclua palavras que um orchestrator realmente usaria

## Gatilhos ruins

- "helpful agent"
- "general coding assistant"
- descricoes sem contexto local, sem trigger phrase e sem dominio claro

## Checklist curto

- o nome do arquivo comunica dominio e papel?
- o `name` visivel nao contradiz o papel do arquivo?
- a `description` diz quando usar e o que esperar da resposta?
- o corpo reforca as mesmas fronteiras do frontmatter?
- a lista `agents` so existe quando a tool `agent` tambem existe?