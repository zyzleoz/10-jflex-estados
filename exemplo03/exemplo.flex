/* 
 * Analisador léxico para comentários multilinha (/* ... */).
 * Ignorar o conteúdo fora dos comentários.
 * Armazenar o texto do comentário em uma variável.
 * Imprimir o comentário capturado ao final.
 */

%%

%standalone    // Habilita execução sem JCup.
%class Scanner // Nome da classe gerada.

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();
%}

%states COMENTARIO

%%
<YYINITIAL> {
    "/*"    { yybegin(COMENTARIO); comentario.setLength(0); }  // Inicia o comentário.
    [^]     { /* Ignora qualquer caracter fora de comentários. */ }
}

<COMENTARIO> {
    "*/" { 
        yybegin(YYINITIAL); 
        System.out.println("Comentário capturado:\n" + comentario.toString()); 
    }
    [^*/\n\r]+  { comentario.append(yytext()); }  // Tudo que não é *, / ou quebra
    "*"        { comentario.append('*'); }
    "/"        { comentario.append('/'); }
    \n         { comentario.append('\n'); }
    \r         { comentario.append('\r'); }
}

// Fora do comentário: ignora espaços/tabulações:
[ \t]    { /* Ignora. */ }

/*

OBS:

YYINITIAL: estado inicial. Ao encontrar \/*, muda para COMENTARIO.

COMENTARIO: captura tudo até *\/, tratando * e quebras de linha.

Variável comentario:

StringBuilder é usado para eficiência ao concatenar textos longos.

Tratamento Especial:

[^*]+ captura qualquer caractere que não seja *.

"*" adiciona um * isolado ao comentário (evita falsos *\/).

Preservação de Formatação: o \n é explicitamente adicionado para manter as quebras de linha originais.


Como testar? 

Mudar de diretório:
cd ../exemplo03/ 

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

