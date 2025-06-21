/* 
 * Analisador léxico para comentários multilinha (\/* ... *\/).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class resumo // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states COMENTARIO

%%



<YYINITIAL> {
    "<BR><CENTER><B>Abstract</B></CENTER><P>"   { yybegin(COMENTARIO); comentario.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<COMENTARIO> {
    "</P><HR>" { 
        yybegin(YYINITIAL); 
        System.out.println("Resumo da patente:\n" + comentario.toString()); 
    }
    [\w* \s* \'-.]   { comentario.append(yytext()); } 
}

/*

Como testar? 

jflex resumo.flex

javac resumo.java

Jogando a saída num arquivo:

java resumo p7022487.html > saidaresumo.txt


Git

git add .

git commit -m "Exemplo"

git push

*/

