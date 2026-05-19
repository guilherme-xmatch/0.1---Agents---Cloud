# Blueprint de agent

Todo agent bem desenhado precisa fechar estes blocos:

1. `missao`
   - o que ele resolve em uma frase clara
2. `gatilhos de descoberta`
   - palavras reais que outro agent ou o usuario usaria para invoca-lo
3. `tool surface`
   - o menor conjunto de tools que permite cumprir a missao
4. `modelo`
   - rapido, forte ou fallback conforme o papel
5. `fronteiras`
   - o que o agent nunca faz
6. `abordagem`
   - passos curtos e repetiveis
7. `output format`
   - exatamente o que ele devolve ao chamador

Se um desses blocos estiver vago, o agent tende a ficar amplo demais ou dificil de delegar.