/* 
 * Exemplo de analisador léxico que armazena comentários entre "...", 
 * trata corretamente caracteres escapados como \" \\ \n \t etc
 * e imprime o conteúdo do comentário na tela.
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variável para armazenar o conteúdo do comentário:
    private String conteudoComentario = "";
%}

// Define um estado personalizado para ler strings:
%states STRING  

%%

<YYINITIAL> {
    // Ao encontrar aspas, inicia a leitura da string:
    \" { yybegin(STRING); conteudoComentario = ""; }
    
    // Ignora qualquer outro caractere fora de strings:
    [^] { /* Ignora. */}
}

<STRING> {
    // Aspa escapada (\" -> adiciona uma aspa escapada):
    \\\" { conteudoComentario += "\""; }

    // Barra invertida escapada (\\ -> adiciona uma barra invertida escapada):
    \\\\ { conteudoComentario += "\\"; }

    // Quebra de linha escapada (\n -> adiciona nova linha escapada):
    \\n { conteudoComentario += "\n"; }

    // Tabulação escapada (\t -> adiciona caracter de tabulação escapado):
    \\t { conteudoComentario += "\t"; }

    // Fecha a string ao encontrar aspas não escapadas:
    \" {
        yybegin(YYINITIAL);
        System.out.println("Conteúdo do comentário: " + conteudoComentario + ".");
    }

    // Adiciona ao conteúdo qualquer sequência de caracteres que não sejam barra ou aspas:
    [^\\\"]+ { conteudoComentario += yytext(); }

    // Captura qualquer outro caractere isolado (ex: uma barra sozinha, ou caracteres não tratados):
    . { conteudoComentario += yytext(); }
}

/*

Como testar? 

cd exemplo01/ 

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

