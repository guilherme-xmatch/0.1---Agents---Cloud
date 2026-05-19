# MCP compartilhado vs pessoal

Compartilhe no repo apenas o que o time inteiro deve herdar.

Use config pessoal quando:

- a integracao depende de credenciais ou contexto individual
- a ferramenta ainda nao tem maturidade para virar baseline
- o blast radius e alto demais para ficar habilitado por default

Use `.sample` ou `.template` quando o time quer ensinar o setup sem ativar o servidor imediatamente.