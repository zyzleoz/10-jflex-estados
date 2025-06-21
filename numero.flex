/* 
 * Analisador léxico para comentários multilinha (\/* ... *\/).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class numero // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states COMENTARIO

%%



<YYINITIAL> {
    "<TD ALIGN=\"RIGHT\" WIDTH=\"50%\"><B>"   { yybegin(COMENTARIO); comentario.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<COMENTARIO> {
    "</B></TD>" { 
        yybegin(YYINITIAL); 
        System.out.println("Número da patente capturado:\n" + comentario.toString()); 
    }
    [0-9]","[0-9]{3}","[0-9]{3}  { comentario.append(yytext()); } 
}

/*

Como testar? 

jflex numero.flex

javac numero.java

Jogando a saída num arquivo:

java numero p7022487.html > saidanumero.txt


Git

git add .

git commit -m "Exemplo"

git push

*/

