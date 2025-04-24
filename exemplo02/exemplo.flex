/* 
 * Analisador léxico que captura:
 * 1. Texto entre aspas duplas ("..."). 
 * 2. Texto entre aspas simples ('...') DENTRO das aspas duplas.
 * 3. Suporte a escapes como \", \', \\
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variáveis para armazenar os conteúdos:
    private String conteudoAspasDuplas = "";
    private String conteudoAspasSimples = "";
%}

// Define os nomes dos estados personalizados para ler comentários:
%states STRING_DUPLA, STRING_SIMPLES 

%%

<YYINITIAL> {
    // Ignora espaços, quebras de linha, etc. 
    [ \t\n\r] { /* Ignora. */ }

    // Ao encontrar aspas duplas, inicia leitura da string principal
    \" {
        yybegin(STRING_DUPLA);
        conteudoAspasDuplas = "";
    }

    [^] { /* Ignora outros caracteres fora de strings */ }
}

<STRING_DUPLA> {
    // Fecha a string de aspas duplas:
    \" {
        yybegin(YYINITIAL);
        System.out.println("Conteúdo entre aspas duplas: \"" + conteudoAspasDuplas + "\"");
    }

    // Entra em string de aspas simples se estiver dentro da dupla:
    \' {
        yybegin(STRING_SIMPLES);
        conteudoAspasSimples = "";
    }

    // Trata escapes primeiro (ordem importa!):
    \\\\ { conteudoAspasDuplas += "\\"; }
    \\\" { conteudoAspasDuplas += "\""; }
    \\\' { conteudoAspasDuplas += "'"; }

    // Adiciona qualquer coisa que não seja barra ou aspas:
    [^\\\"\'\n\r]+ { conteudoAspasDuplas += yytext(); }  
    
    // Qualquer outro caractere (como uma barra isolada etc.):
    . { conteudoAspasDuplas += yytext(); }
}

<STRING_SIMPLES> {
    // Fecha string simples:
    \' {
        yybegin(STRING_DUPLA);
        System.out.println("  Conteúdo entre aspas simples: '" + conteudoAspasSimples + "'");
    }

    // Trata escapes primeiro:
    \\\\ { conteudoAspasSimples += "\\"; }
    \\\" { conteudoAspasSimples += "\""; }
    \\\' { conteudoAspasSimples += "'"; }  

    // Adiciona qualquer coisa que não seja barra ou aspa
    [^\\\'\n\r]+ { conteudoAspasSimples += yytext(); }

    // Qualquer outro caractere isolado
    . { conteudoAspasSimples += yytext(); }
}

/*

OBS:

STRING_DUPLA: ativo dentro de "...".

STRING_SIMPLES: ativo dentro de '...' (só se estiver dentro de STRING_DUPLA).


Como testar? 

Mudar de diretório:
cd exemplo02/ 

Salvar o código num arquivo exemplo.jflex.

jflex exemplo.flex

javac Scanner.java

java Scanner entrada01.txt

java Scanner entrada02.txt

Jogando a saída num arquivo:

java Scanner entrada01.txt > saida01.txt

java Scanner entrada02.txt > saida02.txt

Git

git add .

git commit -m "Exemplo"

git push

*/

