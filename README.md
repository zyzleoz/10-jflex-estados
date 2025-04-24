# 10-jflex-estados

# Jflex
Instalação:

`sudo apt update`

`sudo apt install jflex`

# Estados
Estados em JFlex são usados para lidar com contexto diferentes durante a análise léxica (como um "modo" em que o analisador pode entrar e sair). 

# O que são estados no JFlex?
São "ambientes", ou modos, que definem quais regras léxicas devem ser ativadas em determinado momento. 

Exemplo:

Se você está lendo um comentário no código, não quer que regras para determinar identificadores ou números sejam aplicadas.

Estados ajudam a isolar regras específicas para contextos específicos.

# Por que foram criados?
Problema: linguagens têm estruturas complexas (comentários multilinha, strings, blocos de código) que exigem tratamento diferenciado.

Solução: estados permitem que o analisador léxico "mude de comportamento" conforme o contexto, sem misturar regras.

# Para que servem?
Organização: estruturar regras léxicas, evitar conflitos entre regras.

Exemplo: 
Uma aspa dentro de um comentário não deve ser tratada como string.

Eficiência: O analisador léxico só avalia regras relevantes para o estado atual.

Controle: transições entre estados são explícitas.

Exemplo: ao encontrar /*, entra no estado COMMENT.

# Estados pré-definidos no JFlex
__YYINITIAL__: é o estado padrão (inicial) do analisador léxico. Todas as regras sem estado explícito pertencem a ele.

__YYSTRING__, __YYCOMMENT__: são nomes comuns para estados personalizados, mas você pode definir os seus.

Logo:

Nomes livres: você pode nomear estados como quiser (MODE_HTML, MODE_JS, etc).


# Como definir estados customizados?
No arquivo .flex, você declara estados na seção %% antes das regras:

flex:
```

%%

%{
  // Código Java opcional.
%}

// Declaração de estados (exemplo):
%states COMMENT, STRING

%%
// Regras:
<YYINITIAL> {
  "/*"   { yybegin(COMMENT); } // Entra no estado COMMENT.
  "\""   { yybegin(STRING);  } // Entra no estado STRING.
}

<COMMENT> {
  "*/"   { yybegin(YYINITIAL); } // Fecha o comentário. Volta ao estado inicial.
  [^]    { /* Ignora qualquer caracter. */ }
}

<STRING> {
  "\""     { yybegin(YYINITIAL); } // Fecha string. Volta ao estado inicial.
  "\\\""   { /* Trata aspas escapadas */ }
  [^\"]+   { /* Adiciona à string */ }
}

```

# Como funcionam as transições?
yybegin(ESTADO): muda para o estado ESTADO.

Regras só são avaliadas se o analisador léxico estiver no estado especificado.

# Exemplo prático
Suponha que você queira ler um JSON:

No estado YYINITIAL, você identifica chaves ({, }).

Ao encontrar ", entra no estado STRING para ler até a próxima ".

Dentro de STRING, ignora regras de outros tokens (como números).


# Resumo
```
Conceito	     Exemplo JFlex
Estado padrão	 YYINITIAL
Criar estado	 %states MEU_ESTADO
Mudar de estado	 yybegin(ESTADO)
```

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