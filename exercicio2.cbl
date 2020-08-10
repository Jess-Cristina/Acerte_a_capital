      $set sourceformat"free"


      *>Divisão de identificação do programa
       Identification Division.
       Program-id. "exercicio2".
       Author. "Jéssica C.Del'agnolo".
       Installation. "PC".
       Date-written. 09/07/2020.
       Date-compiled. 09/07/2020.



      *>Divisão para configuração do ambiente
       Environment Division.
       Configuration Section.
           special-names. decimal-point is comma.

      *>----Declaração dos recursos externos
       Input-output Section.
       File-control.

                  select alt assign to "altenativas.txt"
                  organization is line sequential
                  access mode is sequential
                  file status is ws-fs-alter.

       I-O-Control.

      *>Declaração de variáveis
       Data Division.

      *>----Variaveis de arquivos
       File Section.

       fd alt.
       01 fd-alternativas.
          05 fd-estado                             pic x(25).
          05 fd-capital                            pic x(25).



      *>----Variaveis de trabalho
       Working-storage Section.

       77 ws-fs-alter                              pic 9(02).

       01 ws-jogadores occurs 4.
          05 ws-posicao_final                      pic x(08)
                                                   value "-".
          05 filler                                pic x(02)
                                                   value "  ".
          05 ws-nome                               pic x(10).
          05 filler                                pic x(05)
                                                   value "  -  ".
          05 ws-qtd_pontos                         pic 9(02).

       01 ws-jogadores_aux.
          05 ws-posicao_final_aux                  pic x(08)
                                                   value "-".
          05 filler                                pic x(02)
                                                   value "  ".
          05 ws-nome_aux                           pic x(10).
          05 filler                                pic x(05)
                                                   value "  -  ".
          05 ws-qtd_pontos_aux                     pic 9(02).

       01 ws-cabecalho.
          05 ws-posicao_final_cabec                pic x(08)
                                                   value "Posicao".
          05 filler                                pic x(02)
                                                   value "  ".

          05 ws-nome_cabec                         pic x(10)
                                                   value "Jogador".
          05 filler                                pic x(05)
                                                   value "  -  ".
          05 ws-qtd_pontos_cabec                   pic x(06)
                                                   value "Pontos".

       01 ws-alternativas occurs 27.
          05 ws-estado                             pic x(25).
          05 ws-capital                            pic x(25).

       77 ws-num_random                            pic 9(01)v9(08).
       77 ws-semente                               pic 9(08).
       77 ws-aux                                   pic 9(08).
       01 ws-relogio.
          05 ws-hora                               pic 9(02).
          05 ws-min                                pic 9(02).
          05 ws-seg                                pic 9(02).
          05 ws-cent_seg                           pic 9(02).
       77 ws-num_ale                               pic 9(02).
       77 ws-ind_jogadores                         pic 9(02).
       77 ws-menu_jogadores                        pic 9(01).
       77 ws-num_jogadores                         pic 9(01).
       77 ws-continuar                             pic x(01).
       77 ws-ind_capitais                          pic 9(02).
       77 ws-resposta                              pic x(25).
       77 ws-controle                              pic x(10).

      *>----Variaveis para comunicação entre programas
       Linkage Section.

      *>----Declaração de tela
       Screen Section.


      *>Declaração do corpo do programa
       Procedure Division.

           perform inicializa.
           perform cadastro_capital.
           perform cadastra_jogadores.
           perform jogar.
           perform ordena_resultado.
           perform exibe_resultado.
           perform finaliza.

       inicializa section.

           move 0 to ws-ind_jogadores              *> Inicializa variaveis
           move 0 to ws-num_jogadores
           move 0 to ws-menu_jogadores

           .
       inicializa-exit.
           exit.

       *>----------------------------------------------------------------------
       *> Cadastro de Jogadores
       *>----------------------------------------------------------------------
       cadastra_jogadores section.

           perform until ws-menu_jogadores = "2"

               add 1 to ws-ind_jogadores

               display erase

               if  ws-ind_jogadores <= 4 then
                   display "Insira o Nome do Jogador " ws-ind_jogadores ":"
                   accept ws-nome(ws-ind_jogadores)
                   add 1 to ws-num_jogadores
               else
                   display "Numero Maximo de Jogadores Atingido."
                   display " "
               end-if

               display "Deseja Cadastrar Novo Jogador?"
               display "1 - Sim."
               display "2 - Nao, Inicie o Jogo."
               accept ws-menu_jogadores
           end-perform


           .
       cadastra_jogadores-exit.
           exit.
       *>----------------------------------------------------------------------
       *> Iniciar o jogo
       *>----------------------------------------------------------------------
       jogar section.

           display erase

           display "--- Vamos Jogar: Acerte a Capital! ---"
           display " "
           display "Atencao: "
           display "Para a Resposta Ser Validada, As Capitais Devem Ser Declaradas com a Primeira "
           display "Letra de Cada Nome em Maiucula. O Programa Nao Aceita Acentuacoes. Caso a "
           display "Resposta Nao Siga Os Criterios Descritos, a Resposta Sera Tida Como"
           display "Incorreta."
           display " "
           display "Pressione Enter Para Continuar."
           accept ws-continuar

           move 1 to ws-ind_jogadores

           perform ws-num_jogadores times
               move 0 to ws-qtd_pontos(ws-ind_jogadores)
               add 1 to ws-ind_jogadores
           end-perform

           perform 20 times
               move 1 to ws-ind_jogadores
               perform sorteio

               perform ws-num_jogadores times
                   display erase
                   display ws-nome(ws-ind_jogadores) "Eh a Sua Vez"
                   display " "
                   display "Pressione Enter para Responder:"
                   accept ws-continuar

                   display "Qual eh a Capital do Estado " ws-estado(ws-ind_capitais)"?"
                   accept ws-resposta

                   if ws-resposta = ws-capital(ws-ind_capitais) then
                       display "Resposta Correta!"
                       add 1 to ws-qtd_pontos(ws-ind_jogadores)
                   else
                       display "Resposta Incorreta."
                   end-if

                   display " "
                   display "Pressione Enter e Passe para o Proximo Jogador."
                   accept ws-continuar
                   add 1 to ws-ind_jogadores
               end-perform
           end-perform

           .
       jogar_exit.
           exit.

       *>-----------------------------------------------------------------------
       *>  Exibir resultados
       *>-----------------------------------------------------------------------
       exibe_resultado section.

           display erase
           display "O Ganhador eh " ws-nome(1) " ,Parabens!"
           display " "
           display "Tabela de Resultados:"
           display " "
           display ws-cabecalho

           move 1 to ws-ind_jogadores

           perform ws-num_jogadores times
               display ws-jogadores(ws-ind_jogadores)
               add 1 to ws-ind_jogadores
           end-perform

           .
       exibe_resultado-exit.
           exit.

       *>-----------------------------------------------------------------------
       *>  Ordenação de resultado
       *>-----------------------------------------------------------------------
       ordena_resultado section.

           move "continua" to ws-controle
           perform until ws-controle <> "continua"
               move 1 to ws-ind_jogadores
               move "n_continua" to ws-controle
               perform until ws-ind_jogadores =  ws-num_jogadores
                   if ws-qtd_pontos(ws-ind_jogadores) < ws-qtd_pontos(ws-ind_jogadores + 1) then
                       move ws-jogadores(ws-ind_jogadores + 1) to ws-jogadores_aux
                       move ws-jogadores(ws-ind_jogadores) to ws-jogadores(ws-ind_jogadores + 1)
                       move ws-jogadores_aux to ws-jogadores(ws-ind_jogadores)

                       move "continua" to ws-controle
                   end-if
                   add 1 to ws-ind_jogadores
               end-perform
           end-perform

           move "Primeiro" to ws-posicao_final(1)
           move "Segundo"  to ws-posicao_final(2)
           move "Terceiro" to ws-posicao_final(3)
           move "Quarto"   to ws-posicao_final(4)

           .
       ordena_resultado-exit.
           exit.

       *>-----------------------------------------------------------------------
       *>  Cadastro das alternativas (Capitais)
       *>-----------------------------------------------------------------------
       cadastro_capital section.

           open input alt

           if  ws-fs-alter <> 0 then
               display "File Status ao abrir input arquivo: " ws-fs-alter
           end-if

           move 0 to ws-ind_capitais

           perform 27 times
               add 1 to ws-ind_capitais
               *> -------------  Salvar dados no arquivo
               read alt
               if  ws-fs-alter <> 0
               and ws-fs-alter <> 10 then
                   display "File Status ao escrever arquivo: " ws-fs-alter
               end-if

               move  fd-alternativas       to  ws-alternativas(ws-ind_capitais)
               *> -------------

           end-perform

           close alt
           if ws-fs-alter <> 0 then
               display "File Status ao fechar arquivo: " ws-fs-alter
           end-if

           .
       cadastro_capital-exit.
           exit.

       *>-----------------------------------------------------------------------
       *>  Sorteio de capitais
       *>-----------------------------------------------------------------------
       sorteio section.

           move 0 to ws-relogio
           move 0 to ws-semente

      *>   Gerar semente para numero aleatório através da hora
           accept ws-relogio from time

           move   ws-relogio to ws-aux

           multiply ws-aux by 13 giving ws-semente

      *>   Gerando o numero aleatório
           compute ws-num_random = function random(ws-semente)

           multiply ws-num_random by 27 giving ws-num_ale

           move ws-num_ale to ws-ind_capitais

           .
       sorteio-exit.
           exit.

       finaliza section.

           Stop Run

           .
       finaliza-exit.
           exit.













