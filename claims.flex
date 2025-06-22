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
    private StringBuilder claims = new StringBuilder();
%}

%states CLAIMS

%%



<YYINITIAL> {
    "<CENTER><B><I>Claims</B></I></CENTER> <HR> <BR><BR>"   { yybegin(CLAIMS); claims.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<CLAIMS> {
    "<HR> <CENTER><B><I> Description</B></I></CENTER> <HR>" { 
        yybegin(YYINITIAL); 
        System.out.println("Reivindicações da patente:\n" + claims.toString()); 
    }
    [\w* \s* \'-.,:;<>]   { claims.append(yytext()); } 
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

