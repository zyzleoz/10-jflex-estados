/* Analisador léxico para comentários de 
 * linha única (// ...) COM USO DE ESTADOS.
 */

%%

%standalone    // Habilitar a execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variável para armazenar o comentário:
    private StringBuilder comentario = new StringBuilder();
%}

%states LINHA_COMENTARIO // Nome personalizado do estado.

%%
<YYINITIAL> {
    "//"    { 
        yybegin(LINHA_COMENTARIO); 
        comentario.setLength(0);  // Limpar o buffer.
    }
    [^]     { /* Ignorar qualquer caracter fora de comentários. */ }
}

<LINHA_COMENTARIO> {
    \n { 
        yybegin(YYINITIAL);  // Voltar para o estado inicial ao fim da linha.
        System.out.println("Comentário: " + comentario.toString()); 
    }
    [^\n]+  { comentario.append(yytext()); }  // Capturar tudo até a quebra de linha.
}

// Ignorar espaços, tabulações e quebras de linha fora do comentário.
[ \t\r] { /* Ignorar. */ }

/*

OBS:

YYINITIAL: estado inicial.

Ao encontrar //, muda para o estado LINHA_COMENTARIO e limpa o buffer.

Ignora todos os outros caracteres.

LINHA_COMENTARIO: Estado do comentário.

[^\n]+: captura tudo exceto quebra de linha e armazena no StringBuilder.

\n: ao encontrar uma quebra de linha, volta ao estado YYINITIAL e imprime o comentário.

Vantagens dessa abordagem:
Clareza: separação explícita entre o contexto normal e o de comentário.

Escalabilidade: fácil adição de novos estados (ex.: para comentários multilinha ou strings).

Controle preciso: transições de estado são visíveis e gerenciáveis.

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

