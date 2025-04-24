# Atividade

## Web Scraping e JFlex
Web Scraping é a técnica de extrair dados de páginas Web automaticamente. Ela permite coletar informações como notícias, preços, estatísticas ou qualquer conteúdo disponível publicamente na Web. 

Apesar de JFlex não ser uma ferramenta de scraping em si, ele pode ajudar na análise e extração de dados estruturados ou semiestruturados em páginas HTML. Imagine que você já obteve o conteúdo HTML (por exemplo, salvou a página como texto). Nesse ponto, o JFlex pode ser usado como um analisador léxico personalizado, para:

1) Reconhecer padrões específicos no HTML (como `<div class="produto">` ou `<span class="preco">`).

2) Extrair dados com regras bem definidas.

3) Separar tokens úteis do ruído HTML (como tags e espaços).

4) Facilitar o pós-processamento dos dados coletados.

Nessa atividade, você está recebendo uma patente americana (United States Patent: 7022487). Usando JFlex, desenvolva um analisador léxico que identifique o seguintes campos da patente:

1) Número (number).
2) Título.
3) Data de publicação.
4) Resumo (abstract).
5) Reivindicações (claims).