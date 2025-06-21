/* 
 * Analisador léxico para comentários multilinha (\/* ... *\/).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class data // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states COMENTARIO

%%



<YYINITIAL> {
    "<TD ALIGN=\"RIGHT\" WIDTH=\"50%\"> <B>"   { yybegin(COMENTARIO); comentario.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<COMENTARIO> {
    "</B></TD></TR></TABLE>" { 
        yybegin(YYINITIAL); 
        System.out.println("Data da patente:\n" + comentario.toString()); 
    }
    [a-zA-Z]+ \s [0-9]"," \s [0-9]{4}  { comentario.append(yytext()); } 
}

/*

Como testar? 

jflex data.flex

javac data.java

Jogando a saída num arquivo:

java data p7022487.html > saidadata.txt


Git

git add .

git commit -m "Exemplo"

git push

*/

