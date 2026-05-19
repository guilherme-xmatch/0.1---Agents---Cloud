---
description: Materialize and validate a specialist repository skill for creating GitHub Copilot agents in VS Code using the prior session audit and design outputs.
model: Auto
tools: ['search/codebase', 'search/usages', 'edit', 'web/fetch', 'runSubagent', 'agent']
---

# Prompt 3: materializar e validar a skill especialista em criacao de agents

Continue exatamente da mesma sessao e use como entrada obrigatoria:

- o diagnostico final do Prompt 1
- o blueprint final do Prompt 2

Nao redesenhe a arquitetura de novo. Agora a meta e materializar o que ja foi decidido com o menor numero de arquivos e a maior clareza possivel.

## Objetivo

Criar ou atualizar no repositorio uma skill realmente especialista em criacao de agents locais do GitHub Copilot no VS Code, com arquivos de apoio suficientes para ela ser reutilizavel, auditavel e sustentavel.

## Escopo de implementacao

Implemente apenas o que for necessario para a skill alvo funcionar bem. Tipicamente isso inclui:

- `.github/skills/<nome-da-skill>/SKILL.md`
- `references/` com resumos de alta utilidade
- `checklists/` com gates operacionais
- `templates/` com esqueletos de `*.agent.md`
- ajustes no `README.md` do catalogo de skills e, se necessario, no catalogo de agents

## Regras obrigatorias durante a implementacao

1. Preserve a taxonomia atual do repositorio.
2. Nao duplique conhecimento que ja existe em outras skills sem um bom motivo.
3. Extraia para `references/`, `checklists/` e `templates/` tudo o que tornar o `SKILL.md` grande demais.
4. Se a skill recomendar uso de `agents`, confira se os templates tambem cobrem a necessidade da tool `agent`.
5. Se um template de prompt induzir subagents, deixe isso explicito.
6. Nao introduza formatos legados.
7. Nao use segredos nem configuracoes inseguras.

## Validacao obrigatoria

Depois de editar:

1. valide se `name` do `SKILL.md` bate com a pasta
2. valide frontmatter e `description`
3. valide links relativos
4. valide coerencia com o catalogo atual de skills e agents
5. diga o que foi criado, o que foi atualizado e o que ficou de fora

## Delegacao recomendada

Se precisar de apoio durante a implementacao, use:

- `copilot-vscode-engenheiro-customizacoes.agent.md`
- `copilot-vscode-orquestrador-subagents.agent.md`
- `copilot-vscode-auditor-setup.agent.md`

## Formato obrigatorio da resposta final

1. skill criada ou atualizada
2. arquivos criados ou modificados
3. validacoes executadas
4. riscos ou lacunas restantes
5. proximo passo opcional

## Regra final

So encerre quando a skill estiver materializada e validada, ou quando houver um bloqueio real explicitado com clareza.