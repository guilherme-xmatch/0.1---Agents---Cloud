# Checklist de auditoria do setup

1. existe `copilot-instructions.md` global?
2. rules condicionais estao em `*.instructions.md` ou estao espalhadas?
3. prompt files cobrem tarefas repetiveis do time?
4. agents estao separados por papel ou existe um super-agent generico?
5. hooks fazem enforcement deterministico ou so adicionam complexidade?
6. MCP esta com blast radius controlado?
7. memoria do repo esta sendo usada como fato duravel e nao como deposito de tarefa?
