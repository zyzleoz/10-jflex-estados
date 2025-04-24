/* 
 * Analisador léxico para comentários de linha única (// ...).
 * Ignorar todo o conteúdo fora de comentários.
 * Capturar o texto após // até o fim da linha.
 * Imprimir na tela cada comentário encontrado com linha e coluna.
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha.
%column        // Habilita rastreamento da coluna.

%{
    // Método auxiliar para imprimir comentários:
    private void imprimirComentario(String texto) {
        System.out.println("Comentário (linha: " + yyline + ", coluna: " + yycolumn + "): " + texto.trim());
    }
%}

%%

// Regras:
"//"[^\n]*   { imprimirComentario(yytext().substring(2)); }  // Captura o comentário sem o "//".
[ \t\r\n]+   { /* Ignora espaços, tabs e quebras de linha. */ }
.            { /* Ignora qualquer outro caractere. */ }

/*

OBS:

//: início do comentário.

[^\n]*: captura qualquer caractere exceto quebra de linha (\n).

yytext().substring(2): remove os // antes de imprimir.

[ \t\r\n]+: espaços, tabulações e quebras de linhasão ignorados.

.: Qualquer outro caractere fora de comentários é descartado.

Método imprimirComentario: usa trim() para remover espaços extras no início/fim.


Como testar? 

Mudar de diretório:
cd ../exemplo04/ 

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

