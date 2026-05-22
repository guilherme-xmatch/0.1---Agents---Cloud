# Blueprint de agent

Todo agent bem desenhado precisa fechar estes blocos:

1. `missao`
   - o que ele resolve em uma frase clara
2. `gatilhos de descoberta`
   - palavras reais que outro agent ou o usuario usaria para invoca-lo
3. `anti-missao`
   - o que ele explicitamente nao faz
4. `tool surface`
   - o menor conjunto de tools que permite cumprir a missao
5. `modelo`
   - rapido, forte ou fallback conforme o papel
6. `subagents e handoffs`
   - quem ele pode chamar e o que precisa receber de volta
7. `abordagem`
   - passos curtos e repetiveis
8. `output format`
   - exatamente o que ele devolve ao chamador
9. `ownership e overlap`
   - por que esse agent existe sem duplicar um papel ja coberto no catalogo
10. `validacao`
   - que checks precisam passar antes de considerar o agent pronto

Se um desses blocos estiver vago, o agent tende a ficar amplo demais ou dificil de delegar.

Perguntas de controle:

- por que esse problema pede um `.agent.md` e nao um prompt file ou uma instruction?
- qual agent atual ele complementa e qual agent atual ele nao deve substituir?
- o que o chamador recebe no fim sem precisar reinterpretar a resposta inteira?