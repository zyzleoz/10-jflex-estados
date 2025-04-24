/* 
 * Analisador léxico que captura:
 * 1. Texto entre aspas duplas ("..."). 
 * 2. Texto entre aspas simples ('...') DENTRO das aspas duplas.
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variáveis para armazenar os conteúdos:
    private String conteudoAspasDuplas = "";
    private String conteudoAspasSimples = "";
    private boolean dentroDeAspasDuplas = false;
%}

%states STRING_DUPLA, STRING_SIMPLES // Define os nomes dos estados personalizados para ler comentários.

%%

<YYINITIAL> {
    "\"" { 
        yybegin(STRING_DUPLA); 
        conteudoAspasDuplas = "";
        dentroDeAspasDuplas = true;
    }
    [^] { /* Ignora outros caracteres fora de strings */ }
}

<STRING_DUPLA> {
    "\"" { 
        yybegin(YYINITIAL);
        dentroDeAspasDuplas = false;
        System.out.println("Conteúdo entre aspas duplas: \"" + conteudoAspasDuplas + "\"");
    }
    "\'" { 
        if (dentroDeAspasDuplas) {
            yybegin(STRING_SIMPLES);
            conteudoAspasSimples = "";
        } else {
            conteudoAspasDuplas += "'";
        }
    }
    "\\"["\"""\'""\\"] { conteudoAspasDuplas += yytext().substring(1); }  // Trata escapes (\", \', \\).
    [^\'\"]+ { conteudoAspasDuplas += yytext(); }
}

<STRING_SIMPLES> {
    "\'" { 
        yybegin(STRING_DUPLA);
        System.out.println("  Conteúdo entre aspas simples: '" + conteudoAspasSimples + "'");
    }
    "\\"["\"""\'\\] { conteudoAspasSimples += yytext().substring(1); }  // Trata escapes (\", \', \\).
    [^\']+ { conteudoAspasSimples += yytext(); }
}

// Ignora espaços, quebras de linha, etc. (opcional)
[ \t\n\r] { /* Ignora */ }

/*

OBS:

STRING_DUPLA: ativo dentro de "...".

STRING_SIMPLES: ativo dentro de '...' (só se estiver dentro de STRING_DUPLA).

Tratamento de Escapes:

Regras como \\[\"\'\\] capturam \", \', e \\ dentro de ambas as strings de comentário.


Controle de Contexto:

A variável dentroDeAspasDuplas evita que aspas simples fora de aspas duplas sejam tratadas como comentários.


Como testar? 

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

