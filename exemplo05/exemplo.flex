/* 
 * Analisador léxico para comentários de 
 * linha única (// ...) COM USO DE ESTADO,
 * para controle de contexto.
 */

%%

%standalone    // Habilitar a execução independente (sem JCup).
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha atual.
%column        // Habilita rastreamento da coluna atual.
%type void     // Especifica o tipo de retorno do yylex().

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();

    // Método auxiliar para imprimir o comentário:
    private void imprimirComentario(String texto, int linha, int coluna) {
        System.out.println("Comentário (linha: " + linha + ", coluna: " + coluna + "): " + texto.trim());
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
        imprimirComentario(comentario.toString(), yyline, yycolumn);
        comentario.setLength(0);    // Limpa o buffer.
    }

    [^\n]+ { comentario.append(yytext()); }  // Acumula conteúdo do comentário (captura tudo até a quebra de linha).
}


<<EOF>> {
    // Se o arquivo terminar enquanto estamos no comentário:
    if (comentario.length() > 0) {
        imprimirComentario(comentario.toString(), yyline, yycolumn);
        comentario.setLength(0);    // Limpa o buffer.
    }
    return; //Termina a execução.
}

/*

OBS:

- YYINITIAL: estado inicial padrão. Ao detectar "//", muda para LINHA_COMENTARIO.
- LINHA_COMENTARIO: captura os caracteres da linha até a quebra de linha (\n).
- A quebra de linha finaliza o comentário e retorna ao estado inicial.
- <<EOF>> garante que comentários no final do arquivo também sejam processados.

Vantagens do uso de estados:
- Clareza no controle de contexto.
- Escalabilidade para lidar com mais padrões (como multilinha).
- Isolamento e transições explícitas entre estados.

Como testar?

cd ../exemplo05/ 
jflex exemplo.flex
javac Scanner.java
java Scanner entrada01.txt
java Scanner entrada02.txt

Jogando a saída num arquivo:

java Scanner entrada01.txt > saida01.txt
java Scanner entrada02.txt > saida02.txt

Git:

git add .
git commit -m "Exemplo"
git push

*/
