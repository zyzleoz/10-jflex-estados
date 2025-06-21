/* 
 * Analisador léxico para comentários multilinha (\/* ... *\/).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class claims // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states COMENTARIO

%%



<YYINITIAL> {
    "<CENTER><B><I>Claims</B></I></CENTER> <HR> <BR><BR>"   { yybegin(COMENTARIO); comentario.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<COMENTARIO> {
    "<HR> <CENTER><B><I> Description</B></I></CENTER> <HR>" { 
        yybegin(YYINITIAL); 
        System.out.println("Resumo da patente:\n" + comentario.toString()); 
    }
    [\w* \s* \'-.,:;<>]   { comentario.append(yytext()); } 
}

/*

Como testar? 

jflex claims.flex

javac claims.java

Jogando a saída num arquivo:

java claims p7022487.html > saidaclaims.txt


Git

git add .

git commit -m "Exemplo"

git push

*/

