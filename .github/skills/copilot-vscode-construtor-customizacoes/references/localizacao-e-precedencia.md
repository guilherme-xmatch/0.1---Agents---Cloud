# Localizacao e precedencia

## Localizacoes padrao

- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `.github/prompts/*.prompt.md`
- `.github/agents/*.agent.md`
- `.github/skills/<skill>/SKILL.md`
- `.github/hooks/*.json`
- `.vscode/mcp.json`

## Heuristicas de precedencia

- prompt file vence tools do custom agent quando ambos definem `tools`
- organizacao vence convencao comunitaria quando houver conflito com a documentacao oficial
- prefira o menor numero de arquivos que resolve o caso sem misturar responsabilidades

## Regra pratica

- artefato compartilhado do time fica no repo
- preferencia individual fica no perfil ou em user memory
