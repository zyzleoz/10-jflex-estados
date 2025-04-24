/* 
 * Analisador léxico para comentários de 
 * linha única (// ...) COM USO DE ESTADO,
 * para controle de contexto.
 */

%%

%standalone    // Habilitar a execução independente (sem JCup).
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha.
%column        // Habilita rastreamento da coluna.
%type void     // Tipo de retorno do yyle

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();

    // Método auxiliar para imprimir o comentário:
    private void imprimirComentario(String texto) {
        System.out.println("Comentário (linha: " + yyline + ", coluna: " + yycolumn + "): " + texto.trim());
    }
%}

// Nome personalizado do estado:
%states LINHA_COMENTARIO 

%%

<YYINITIAL> {
    "//" {
        yybegin(LINHA_COMENTARIO);  // Entra no estado de comentário.
        comentario.setLength(0);    // Limpa o buffer.
    }

    [^] { /* Ignorar qualquer caracter fora de comentários. */ }
}

<LINHA_COMENTARIO> {
    \n {
        yybegin(YYINITIAL);  // Retorna ao estado inicial.
        imprimirComentario(comentario.toString());
        comentario.setLength(0);    // Limpa o buffer.
    }

    [^\n]+ { comentario.append(yytext()); }  // Acumula conteúdo do comentário (captura tudo até a quebra de linha).
}


<<EOF>> {
    // Se o arquivo terminar enquanto estamos no comentário:
    if (comentario.length() > 0) {
        imprimirComentario(comentario.toString());
        comentario.setLength(0);    // Limpa o buffer.
    }
    return; //Termina a execução.
}

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

Mudar de diretório:
cd ../exemplo05/ 

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

