/* 
 * Analisador léxico para comentários multilinha (\/* ... *\/).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class titulo // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder titulo = new StringBuilder();
%}

%states TITULO

%%



<YYINITIAL> {
    "<font size=\"+1\">"   { yybegin(TITULO); titulo.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<TITULO> {
    "</font><BR>" { 
        yybegin(YYINITIAL); 
        System.out.println("Título da patente capturado:\n" + titulo.toString()); 
    }
    [a-zA-Z]* \s*  { titulo.append(yytext()); } 
}

/*

Como testar? 

jflex titulo.flex

javac titulo.java

Jogando a saída num arquivo:

java titulo p7022487.html > saidatitulo.txt


Git

git add .

git commit -m "Exemplo"

git push

*/

