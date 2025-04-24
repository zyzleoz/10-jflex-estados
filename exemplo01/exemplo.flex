/* Exemplo de analisador léxico que armazena comentários entre "..." 
 * e imprime o conteúdo do comentário na tela.
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variável para armazenar o conteúdo do comentário:
    private String conteudoComentario = "";
%}

%states STRING  // Define um estado personalizado para ler strings.

%%

<YYINITIAL> {
    \"  { yybegin(STRING); conteudoComentario = ""; }  // Inicia o estado STRING ao encontrar ".
    [^]   { /* Ignora outros caracteres fora de strings. */ }
}

<STRING> {
    \" { 
        yybegin(YYINITIAL);  // Volta ao estado inicial ao encontrar "
        System.out.println("Conteúdo do comentário: \"" + conteudoComentario + "\""); 
    }
    \\\" { conteudoComentario += "\""; }  // Trata aspas escapadas (\").
    [^\"]+ { conteudoComentario += yytext(); }  // Adiciona o texto ao conteúdo.
}

// Ignora quebras de linha, espaços, etc.
[ \t\n\r] { /* Ignora */ }

/*

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

