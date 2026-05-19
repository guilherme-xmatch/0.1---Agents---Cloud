---
name: copilot-vscode-mcp-governanca
description: Adiciona ou revisa MCP, tool sets, approvals e guardrails no GitHub Copilot local do VS Code. Use quando o trabalho envolver `.vscode/mcp.json`, escolha de ferramentas, seguranca, hooks e blast radius de integracoes externas.
---

# Copilot VS Code: MCP e governanca

Use esta skill quando:

- o usuario pedir para integrar APIs, browser, banco ou sistemas externos via MCP
- voce precisar revisar seguranca e governanca de tools
- o repo tiver duvidas entre config compartilhado, pessoal, `.sample` ou `.template`

Nao use esta skill quando:

- o pedido ainda estiver no nivel de arquitetura geral, sem decisao de introduzir MCP ou rever approvals
- a tarefa for apenas editar um prompt, instruction, skill ou agent sem tocar em integracao externa
- a questao principal for rollout organizacional e ownership de fases

Fatos verificados para aplicar:

- `.vscode/mcp.json` e o lugar oficial para config compartilhado do workspace
- o config do perfil pode ser aberto por `MCP: Open User Configuration`
- MCP pode expor tools, resources, prompts e apps
- `inputs` servem para valores sensiveis e devem ser preferidos a segredos hardcoded
- `Configure Tools` e `Chat: Manage Tool Approval` sao as superficies certas para governar uso e aprovacoes
- `Default Approvals` deve ser o baseline; `Bypass Approvals` e `Autopilot` aumentam muito o risco

Fluxo de trabalho:

1. Justifique cada servidor MCP antes de adiciona-lo.
2. Decida se ele e compartilhado pelo time ou apenas pessoal.
3. Se o time ainda nao confia no setup, prefira `.sample` ou `.template` ao arquivo ativo.
4. Use `inputs` para segredos e valores locais.
5. Revise o conjunto de tools exposto e desligue o que nao for necessario.
6. Adicione hooks ou policies locais so onde houver guardrail deterministico real.

Checklist de risco:

1. ha segredos no repo?
2. o servidor tem blast radius desnecessario?
3. as tools foram reduzidas ao minimo?
4. o time sabe quem aprova o que?
5. existe rollback simples se o MCP causar ruida ou comportamento indevido?

Saida obrigatoria:

1. decisao sobre config ativo, pessoal, `.sample` ou `.template`
2. envelope de tools expostas
3. politica de approvals e segredos
4. owner, rollback e endurecimento recomendado

Padroes recomendados:

- um servidor por necessidade clara
- versionar apenas o que o time inteiro deve herdar
- combinar MCP com prompt file, skill ou agent especifico em vez de liberar geral para tudo

Arquivos de apoio:

- [Dossie principal](../../../docs/13-github-copilot-vscode-local/README.md)
- [Playbook operacional](../../../docs/13-github-copilot-vscode-local/playbook-operacional.md)
- [Padroes comunitarios](../../../docs/13-github-copilot-vscode-local/padroes-comunitarios.md)
- [README local](./README.md)
- [MCP compartilhado vs pessoal](./references/mcp-compartilhado-vs-pessoal.md)
- [Checklist de approvals](./checklists/revisao-de-approvals.md)
- [Template de decisao de MCP](./templates/mcp-governado.template.md)
