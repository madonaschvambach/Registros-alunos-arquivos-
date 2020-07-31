      $set sourceformat"free"


      *>divisão de identificação do programa
       identification division.


      *>--- nome do programa
       program-id. "lista11_num03_Index".
      *>--- nome do autor
       author. "Madona Schvambach".
       installation. "PC".


      *>--- data que o programa foi escrito
       date-written.   27/07/2020.
       date-compiled.  27/07/2020.


      *>divisao para configuracao do programa
       environment division.
       configuration section.


      *>--- declarado que será utilizado vírgulo ao invés de ponto
           special-names. decimal-point is comma.


      *>--- declaracao de recursos eternos
       input-output Section.
       file-control.


       *>nome lógico e e arquivo de memoria
       select arqRegistros assign to "arqRegistros01.txt"
       *>tipo de arquivo (indexado)
       organization    is indexed
       *>modo de acesso ao arquivo (sequencial)
       access mode     is dynamic
       *>evita perda de dados em ambientes multi-usuarios(varios usuarios entrando com dados ao mesmo tempo)
       lock mode is automatic
       *>chave do arquivo
       record key is fd-cod-aluno
       *>variavel "ws-fs-arqAlunos" retona o status do arquivo (0, 35....)
       file status is  ws-fs-arqRegistros.


       i-o-control.


      *>--- declaracao de variaveis
       data division.


      *>--- variáveis de arquivos
       file section.


       fd arqRegistros.
       01  fd-registros-alunos.
           05  fd-cod-aluno                        pic 9(02).
           05  fd-nome-aluno                       pic a(25).
           05  fd-endereco                         pic x(25).
           05  fd-nome-mae                         pic a(25).
           05  fd-nome-pai                         pic a(25).
           05  fd-telefone                         pic x(15).
           05  fd-notas.
               10  fd-nota-01                      pic 9(02)v9(02) value 0.
               10  fd-nota-02                      pic 9(02)v9(02) value 0.
               10  fd-nota-03                      pic 9(02)v9(02) value 0.
               10  fd-nota-04                      pic 9(02)v9(02) value 0.


      *>--- variavéis de trabalho
       working-storage section.

       77  ws-fs-arqRegistros                      pic 9(02).


       01  ws-registros-alunos.
           05  ws-cod-aluno                        pic 9(02) value 0.
           05  ws-nome-aluno                       pic a(25).
           05  ws-endereco                         pic x(25).
           05  ws-nome-mae                         pic a(25).
           05  ws-nome-pai                         pic a(25).
           05  ws-telefone                         pic x(15).
           05  ws-notas.
               10  ws-nota-01                      pic 9(02)v9(02) value 0.
               10  ws-nota-02                      pic 9(02)v9(02) value 0.
               10  ws-nota-03                      pic 9(02)v9(02) value 0.
               10  ws-nota-04                      pic 9(02)v9(02) value 0.


       *>quantidade de notas de cada aluno, neste caso, 4
       77  ws-quant-notas                          pic 9(01) value 4.


       01 ws-msn-erro.
          05 ws-msn-erro-ofsset                    pic 9(04).
          05 filler                                pic x(01) value "-".
          05 ws-msn-erro-cod                       pic 9(02).
          05 filler                                pic x(01) value space.
          05 ws-msn-erro-text                      pic x(42).


       01  ws-opcoes.
           05  ws-cadastrar-alunos                 pic x(01).
           05  ws-cadastrar-notas                  pic x(01).
           05  ws-consultar-situacao               pic x(01).
           05  ws-sair                             pic x(01).
           05  ws-consul-sit-sequencial            pic x(01).
           05  ws-deletar-registro                 pic x(01).
           05  ws-editar-registro                  pic x(01).


       77  ws-escolha                              pic a(15) value "n".
           88   ws-adicionou                       value "s".
           88   ws-n_adicionou                     value "n".


       77  ws-sit-cadastro                         pic x(01) value "n".
           88  ws-cadastrado                       value "s".
           88  ws-n-cadastrado                     value "n".

       77  ws-sair-sit-aluno                       pic  x(01).
           88  ws-sair-sit                         value "N" "n".
           88  ws-continuar                        value "S" "s".

       77  ws-menu-principal                       pic x(01) value "S".
           88  ws-voltar-p-menu                    value "s" "S".
           88  ws-n-voltar-p-menu                  value "n" "n".

       01 ws-mensagens.
           05  ws-mensagem                         pic x(40).
           05  ws-mensagem-sit                     pic x(12).
           05  ws-mensagem-enter                   pic x(40)
               value "Apos consultar, aperte enter".
           05  ws-mensagem-02                      pic x(40) value space.
           05  ws-men-ajuda                        pic x(50) value
               "-- Apos digitar cod. Aluno, aperte enter --".


       77  ws-soma-notas                           pic 9(02)v9(02).
       77  ws-aux-div-notas                        pic 9(02).
       77  ws-media                                pic 9(02)v9(02).
       77  aux_erase                               pic 9(01).


       *>--- variaveis para comunicaçao entre programa
       linkage section.


       *>--- declaração de tela
       screen section.


       01  sc-tela-principal.
           05  blank screen.
           05  line 01 col 04 value    " ---- Sistemas De Cadastros -----  ".
           05  line 04 col 05 value    "MENU                              ".
           05  line 05 col 06 value    "( )Cadastro Do Aluno              ".
           05  line 06 col 06 value    "( )Cadastrar Notas                ".
           05  line 07 col 06 value    "( )Situacao Do Aluno              ".
           05  line 08 col 06 value    "( )Situacao Do Aluno - Sequencial ".
           05  line 09 col 06 value    "( )Deletar Um Registro            ".
           05  line 10 col 06 value    "( )Editar Registro                ".
           05  line 11 col 06 value    "( )Sair                           ".


           05  sc-cada-alunos              line 05 col 07 pic x(01) using ws-cadastrar-alunos.
           05  sc-cada-notas               line 06 col 07 pic x(01) using ws-cadastrar-notas.
           05  sc-cons                     line 07 col 07 pic x(01) using ws-consultar-situacao.
           05  sc-consul-sit-sequencial    line 08 col 07 pic x(01) using ws-consul-sit-sequencial.
           05  sc-deletar-registro         line 09 col 07 pic x(01) using ws-deletar-registro.
           05  sc-editar-registro          line 10 col 07 pic x(01) using ws-editar-registro.
           05  sc-fim                      line 11 col 07 pic x(01) using ws-sair.


       01  sc-cadastar-alunos.
           05  blank screen.
           05  line 01 col 05 value    "------------ Cadastro de Alunos ----------".
           05  line 02 col 05 value    "Codigo Aluno:                             ".
           05  line 03 col 05 value    "Nome Aluno:                               ".
           05  line 04 col 05 value    "Endereco:                                 ".
           05  line 05 col 05 value    "Nome Da Mae:                              ".
           05  line 06 col 05 value    "Nome Do Pai:                              ".
           05  line 07 col 05 value    "Telefone:                                 ".
           05  line 08 col 05 value    "                                          ".
           05  line 09 col 05 value    "  Deseja cadastrar outro aluno(s/n)?( )   ".
           05  line 10 col 05 value    "                                          ".
           05  line 11 col 05 value    "                                          ".
           05  line 12 col 05 value    "                                          ".
           05  line 13 col 05 value    "__________________________________________".


           05  sc-cod-aluno            line 02 col 20 pic 9(02) from  ws-cod-aluno.
           05  sc-nome-do-aluno        line 03 col 20 pic a(25) using ws-nome-aluno.
           05  sc-endereco-aluno       line 04 col 20 pic x(25) using ws-endereco.
           05  sc-nome-mae-aluno       line 05 col 20 pic a(25) using ws-nome-mae.
           05  sc-nome-pai-aluno       line 06 col 20 pic a(25) using ws-nome-pai.
           05  sc-telefone-aluno       line 07 col 20 pic x(15) using ws-telefone.
           05  sc-menu-principal       line 09 col 42 pic x(01) using ws-menu-principal.


       01  sc-tela-entrada-cod-aluno.
           05  blank screen.
           05  line 01 col 10 value    "  ---- Cadastro De Notas - Cod. Aluno  ----  ".
           05  line 03 col 05 value    "Cod. Aluno:                                  ".
           05  line 04 col 05 value    "                                             ".
           05  line 05 col 05 value    "                                             ".
           05  line 06 col 05 value    "                                             ".
           05  line 07 col 05 value    "      Voltar para menu principal (s)? ( )    ".
           05  line 08 col 05 value    "                                             ".
           05  line 09 col 05 value    "                                             ".
           05  line 10 col 05 value    "_____________________________________________".


           05  sc-codigo-aluno         line 03 col 18 pic 9(02) using ws-cod-aluno.
           05  sc-menu-principal       line 07 col 44 pic x(01) using ws-menu-principal.
           05  sc-mensagem             line 09 col 05 pic x(40) from  ws-mensagem  foreground-color 12.
           05  sc-men-ajuda            line 05 col 06 pic x(50) from  ws-men-ajuda foreground-color 10.


       01  sc-tela-entrada-notas.
           05  blank screen.
           05  line 01 col 05 value    "------------ Cadastro de Notas ------------".
           05  line 02 col 05 value    "Entre com as notas de:                     ".
           05  line 04 col 05 value    "Nota 01:                                   ".
           05  line 05 col 05 value    "Nota 02:                                   ".
           05  line 06 col 05 value    "Nota 03:                                   ".
           05  line 07 col 05 value    "Nota 04:                                   ".
           05  line 08 col 05 value    "                                           ".
           05  line 09 col 05 value    "     - Apos cadastrar, aperte enter -      ".
           05  line 10 col 05 value    "___________________________________________".


           05  sc-nome-aluno           line 02 col 28 pic x(25)        from  ws-nome-aluno.
           05  sc-nota-01              line 04 col 14 pic z9,99        using ws-nota-01.
           05  sc-nota-02              line 05 col 14 pic z9,99        using ws-nota-02.
           05  sc-nota-03              line 06 col 14 pic z9,99        using ws-nota-03.
           05  sc-nota-04              line 07 col 14 pic z9,99        using ws-nota-04.


       01  sc-tela-consulta-cadastro.
           05  blank screen.
           05  line 01 col 10 value    " ---- Consulta Do Aluno - Cod. Aluno  ----   ".
           05  line 03 col 05 value    "Cod. Aluno:                                  ".
           05  line 04 col 05 value    "                                             ".
           05  line 05 col 05 value    "                                             ".
           05  line 07 col 05 value    "      Voltar para menu principal (s)? ( )    ".
           05  line 08 col 05 value    "                                             ".
           05  line 09 col 05 value    "                                             ".
           05  line 10 col 05 value    "_____________________________________________".


           05  sc-codigo-aluno         line 03 col 18 pic 9(02) using ws-cod-aluno.
           05  sc-menu-principal       line 07 col 44 pic x(01) using ws-menu-principal.
           05  sc-mensagem             line 09 col 05 pic x(40) from  ws-mensagem  foreground-color 12.
           05  sc-men-ajuda            line 05 col 06 pic x(50) from  ws-men-ajuda foreground-color 10.



       01  sc-tela-dados-aluno.
           05  blank screen.
           05  line 01 col 05 value    "------------ Situacao Do Aluno -----------".
           05  line 02 col 05 value    "Codigo Aluno:                             ".
           05  line 03 col 05 value    "Nome Aluno:                               ".
           05  line 04 col 05 value    "Endereco:                                 ".
           05  line 05 col 05 value    "Nome Da Mae:                              ".
           05  line 06 col 05 value    "Nome Do Pai:                              ".
           05  line 07 col 05 value    "Telefone:                                 ".
           05  line 08 col 05 value    "                                          ".
           05  line 09 col 05 value    "Nota 01:                                  ".
           05  line 10 col 05 value    "Nota 02:                                  ".
           05  line 11 col 05 value    "Nota 03:                                  ".
           05  line 12 col 05 value    "Nota 04:                                  ".
           05  line 13 col 05 value    "Media:                                    ".
           05  line 15 col 05 value    "       Situacao:                          ".
           05  line 16 col 05 value    "                                          ".
           05  line 17 col 05 value    "                                          ".
           05  line 18 col 05 value    "__________________________________________".


           05  sc-cod-aluno            line 02 col 20 pic 9(02) from  ws-cod-aluno.
           05  sc-nome-do-aluno        line 03 col 20 pic a(25) from ws-nome-aluno.
           05  sc-endereco-aluno       line 04 col 20 pic x(25) from ws-endereco.
           05  sc-nome-mae-aluno       line 05 col 20 pic a(25) from ws-nome-mae.
           05  sc-nome-pai-aluno       line 06 col 20 pic a(25) from ws-nome-pai.
           05  sc-telefone-aluno       line 07 col 20 pic x(15) from ws-telefone.
           05  sc-nota-01              line 09 col 20 pic z9,99 from ws-nota-01.
           05  sc-nota-02              line 10 col 20 pic z9,99 from ws-nota-02.
           05  sc-nota-03              line 11 col 20 pic z9,99 from ws-nota-03.
           05  sc-nota-04              line 12 col 20 pic z9,99 from ws-nota-04.
           05  sc-media                line 13 col 20 pic z9,99 from ws-media.
           05  sc-mensagem             line 15 col 22 pic x(12) from ws-mensagem-sit foreground-color 11.
           05  sc-mensagem02           line 17 col 12 pic x(40) from ws-mensagem-enter.


       01  sc-tela-dados-aluno-02.
           05  blank screen.
           05  line 01 col 05 value    "------------ Situacao Do Aluno -----------".
           05  line 02 col 05 value    "Codigo Aluno:                             ".
           05  line 03 col 05 value    "Nome Aluno:                               ".
           05  line 04 col 05 value    "Endereco:                                 ".
           05  line 05 col 05 value    "Nome Da Mae:                              ".
           05  line 06 col 05 value    "Nome Do Pai:                              ".
           05  line 07 col 05 value    "Telefone:                                 ".
           05  line 08 col 05 value    "                                          ".
           05  line 09 col 05 value    "Nota 01:                                  ".
           05  line 10 col 05 value    "Nota 02:                                  ".
           05  line 11 col 05 value    "Nota 03:                                  ".
           05  line 12 col 05 value    "Nota 04:                                  ".
           05  line 13 col 05 value    "Media:                                    ".
           05  line 15 col 05 value    "       Situacao:                          ".
           05  line 17 col 05 value    "                                          ".
           05  line 18 col 05 value    "                                          ".
           05  line 19 col 05 value    "__________________________________________".


           05  sc-cod-aluno            line 02 col 20 pic 9(02) from  ws-cod-aluno.
           05  sc-nome-do-aluno        line 03 col 20 pic a(25) from  ws-nome-aluno.
           05  sc-endereco-aluno       line 04 col 20 pic x(25) from  ws-endereco.
           05  sc-nome-mae-aluno       line 05 col 20 pic a(25) from  ws-nome-mae.
           05  sc-nome-pai-aluno       line 06 col 20 pic a(25) from  ws-nome-pai.
           05  sc-telefone-aluno       line 07 col 20 pic x(15) from  ws-telefone.
           05  sc-nota-01              line 09 col 20 pic z9,99 from  ws-nota-01.
           05  sc-nota-02              line 10 col 20 pic z9,99 from  ws-nota-02.
           05  sc-nota-03              line 11 col 20 pic z9,99 from  ws-nota-03.
           05  sc-nota-04              line 12 col 20 pic z9,99 from  ws-nota-04.
           05  sc-media                line 13 col 20 pic z9,99 from  ws-media.
           05  sc-mensagem             line 15 col 22 pic x(12) from  ws-mensagem-sit foreground-color 11.
           05  sc-mensagem02           line 17 col 12 pic x(40) from  ws-mensagem-enter.
           05  sc-mensagem-02          line 18 col 02 pic x(40) from  ws-mensagem-02.
           05  sc-leitura-voltar       line 18 col 43 pic x(01) using ws-sair-sit-aluno.


       01  sc-tela-deletar-aluno.
           05  blank screen.
           05  line 01 col 10 value    " ----- Deletar Registro - Cod. Aluno -----   ".
           05  line 03 col 05 value    "Cod. Aluno:                                  ".
           05  line 04 col 05 value    "                                             ".
           05  line 05 col 05 value    "                                             ".
           05  line 07 col 05 value    "      Voltar para menu principal (s)? ( )    ".
           05  line 08 col 05 value    "                                             ".
           05  line 09 col 05 value    "                                             ".
           05  line 10 col 05 value    "_____________________________________________".


           05  sc-codigo-aluno         line 03 col 18 pic 9(02) using ws-cod-aluno.
           05  sc-menu-principal       line 07 col 44 pic x(01) using ws-menu-principal.
           05  sc-mensagem             line 09 col 05 pic x(40) from  ws-mensagem  foreground-color 12.
           05  sc-men-ajuda            line 05 col 06 pic x(50) from  ws-men-ajuda foreground-color 10.


       01  sc-tela-cod-alterar-dados.
           05  blank screen.
           05  line 01 col 10 value    " ------ Alterar Dados - Cod. Aluno -------   ".
           05  line 03 col 05 value    "Cod. Aluno:                                  ".
           05  line 04 col 05 value    "                                             ".
           05  line 05 col 05 value    "                                             ".
           05  line 07 col 05 value    "      Voltar para menu principal (s)? ( )    ".
           05  line 08 col 05 value    "                                             ".
           05  line 09 col 05 value    "                                             ".
           05  line 10 col 05 value    "_____________________________________________".

           05  sc-codigo-aluno         line 03 col 18 pic 9(02) using ws-cod-aluno.
           05  sc-menu-principal       line 07 col 44 pic x(01) using ws-menu-principal.
           05  sc-mensagem             line 09 col 05 pic x(40) from  ws-mensagem  foreground-color 12.
           05  sc-men-ajuda            line 05 col 06 pic x(50) from  ws-men-ajuda foreground-color 10.



       01  sc-tela-alterar-dados.
           05  blank screen.
           05  line 01 col 05 value    "--------- Alterar Dados Do Aluno ---------".
           05  line 02 col 05 value    "Codigo Aluno:                             ".
           05  line 03 col 05 value    "Nome Aluno:                               ".
           05  line 04 col 05 value    "Endereco:                                 ".
           05  line 05 col 05 value    "Nome Da Mae:                              ".
           05  line 06 col 05 value    "Nome Do Pai:                              ".
           05  line 07 col 05 value    "Telefone:                                 ".
           05  line 08 col 05 value    "                                          ".
           05  line 09 col 05 value    "Nota 01:                                  ".
           05  line 10 col 05 value    "Nota 02:                                  ".
           05  line 11 col 05 value    "Nota 03:                                  ".
           05  line 12 col 05 value    "Nota 04:                                  ".
           05  line 16 col 05 value    "__________________________________________".


           05  sc-cod-aluno            line 02 col 20 pic 9(02) from   ws-cod-aluno.
           05  sc-nome-do-aluno        line 03 col 20 pic a(25) using  ws-nome-aluno.
           05  sc-endereco-aluno       line 04 col 20 pic x(25) using  ws-endereco.
           05  sc-nome-mae-aluno       line 05 col 20 pic a(25) using  ws-nome-mae.
           05  sc-nome-pai-aluno       line 06 col 20 pic a(25) using  ws-nome-pai.
           05  sc-telefone-aluno       line 07 col 20 pic x(15) using  ws-telefone.
           05  sc-nota-01              line 09 col 20 pic z9,99 using  ws-nota-01.
           05  sc-nota-02              line 10 col 20 pic z9,99 using  ws-nota-02.
           05  sc-nota-03              line 11 col 20 pic z9,99 using  ws-nota-03.
           05  sc-nota-04              line 12 col 20 pic z9,99 using  ws-nota-04.


       *>--- declaracao do corpo do programa
       procedure division.


           perform inicializacao.
           perform processamento.
           perform finalizacao.


      *>------------------------------------------------------------------------
      *>  Inicialização
      *>------------------------------------------------------------------------
       inicializacao section.


           open i-o arqRegistros *> open i-o abre o arquivo para leitura e escrita
           if ws-fs-arqRegistros  <> 00 and ws-fs-arqRegistros <> 05 then
               move 1                                             to ws-msn-erro-ofsset
               move ws-fs-arqRegistros                            to ws-msn-erro-cod
               move "Erro ao inicializar arqRegistros!"           to ws-msn-erro-text
               perform finaliza-anormal

           end-if


           .
       inicializacao-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Processamento
      *>------------------------------------------------------------------------
       processamento section.


           perform until ws-sair = "X" or ws-sair = "x"

               move space to ws-cadastrar-alunos
               move space to ws-cadastrar-notas
               move space to ws-consultar-situacao
               move space to ws-consul-sit-sequencial
               move space to ws-deletar-registro
               move space to ws-editar-registro
               set ws-n-voltar-p-menu to true

               display sc-tela-principal
               accept  sc-tela-principal

               *>-- cadastrar alunos
               if ws-cadastrar-alunos = "X" or ws-cadastrar-alunos = "x" then

                   set ws-voltar-p-menu to true  *>tratamento para funcionar o perform abaixo
                   perform until ws-n-voltar-p-menu
                       perform buscar-prox-cod
                       perform cadastro_aluno
                   end-perform

               else
               *>-- cadastrar notas
               if ws-cadastrar-notas = "X" or ws-cadastrar-notas = "x" then

                   perform cadastrar_notas

               else
               *>-- consultar cadastro com key
               if ws-consultar-situacao = "X" or ws-consultar-situacao = "x" then

                   perform consulta-cadastro

               else
               *>-- consultar cadastro sequencial(next)
               if ws-consul-sit-sequencial = "X" or ws-consul-sit-sequencial = "x" then

                   move space to ws-sair-sit-aluno
                   perform con-cadastro-sequencial

               else
               *>-- deletar registro
               if ws-deletar-registro = "X" or ws-deletar-registro = "x" then

                   perform deletar-registro
                   move fd-registros-alunos to ws-registros-alunos

               else
               *>-- editar registro
               if ws-editar-registro = "X" or ws-editar-registro = "x" then

                   perform alterar-dados

               end-if
           end-perform


           .
       processamento-exit.
           exit.




      *>------------------------------------------------------------------------
      *>  buscar proximo codigo
      *>------------------------------------------------------------------------
       buscar-prox-cod section.

           move space to ws-menu-principal
           *>definindo onde o arqRegistros começa
           move 1 to fd-cod-aluno
           read arqRegistros

           if ws-fs-arqRegistros = 0 then
               perform until ws-fs-arqRegistros = 10

                   *>ler arquivo sequencialmente e add um no fs-cod-aluno
                   read arqRegistros next

                   if ws-fs-arqRegistros <> 0 and ws-fs-arqRegistros <> 10 then
                       move 2                                      to ws-msn-erro-ofsset
                       move ws-fs-arqRegistros                     to ws-msn-erro-cod
                       move "Erro ao ler no arqRegistros!"         to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if

               end-perform
               move fd-cod-aluno to ws-cod-aluno
               add 1 to ws-cod-aluno
           else
               if ws-fs-arqRegistros = 23 then
                   move 1 to ws-cod-aluno
               else
                   move 3                                      to ws-msn-erro-ofsset
                   move ws-fs-arqRegistros                     to ws-msn-erro-cod
                   move "Erro ao ler no arqRegistros!"         to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

           end-if


           .
       buscar-prox-cod-exit.
           exit.



      *>------------------------------------------------------------------------
      *>  Cadastrar alunos
      *>------------------------------------------------------------------------
       cadastro_aluno section.


           move space to ws-nome-aluno
           move space to ws-endereco
           move space to ws-nome-mae
           move space to ws-nome-pai
           move space to ws-telefone

           *>-- entrada aluno
           display sc-cadastar-alunos
           accept  sc-cadastar-alunos

           move ws-registros-alunos to fd-registros-alunos
           write fd-registros-alunos

           if ws-fs-arqRegistros  <> 00 then
               move 4                                      to ws-msn-erro-ofsset
               move ws-fs-arqRegistros                     to ws-msn-erro-cod
               move "Erro ao gravar no arqRegistros!"      to ws-msn-erro-text
               perform finaliza-anormal
           end-if


           .
       cadastro_aluno-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Cadastrar notas
      *>------------------------------------------------------------------------
       cadastrar_notas section.


           perform until ws-voltar-p-menu

               move space to ws-menu-principal
               move 0 to ws-cod-aluno

               display sc-tela-entrada-cod-aluno
               accept  sc-tela-entrada-cod-aluno
               move space to ws-mensagem

               if ws-voltar-p-menu then *>tratamento: caso o usuario digite, ao mesmo tempo, o cod e "s" para voltar p menu, volta imediatamente p menu principal
                   next sentence
               else
                   move    ws-cod-aluno to fd-cod-aluno
                   read arqRegistros

                   if ws-fs-arqRegistros  <> 00 and ws-fs-arqRegistros <> 05 and ws-fs-arqRegistros <> 23 then
                       move 5                                  to ws-msn-erro-ofsset
                       move ws-fs-arqRegistros                 to ws-msn-erro-cod
                       move "Erro ao ler arqRegistros!"        to ws-msn-erro-text
                       perform finaliza-anormal

                   else
                       if ws-fs-arqRegistros = 23 then *>não cadastro no codigo de entrada do usuario

                           move "Codigo invalido!" to ws-mensagem

                       else
                       if ws-fs-arqRegistros = 0 then

                           move space to ws-mensagem
                           move fd-registros-alunos to ws-registros-alunos

                           *>-- entrada das notas
                           display sc-tela-entrada-notas
                           accept  sc-tela-entrada-notas

                           *>conferir se notas são menor que 10
                           perform conferir-tamanho-notas

                           move  ws-notas to fd-notas
                           rewrite fd-registros-alunos

                           if ws-fs-arqRegistros  <> 00 then
                               move 6                                      to ws-msn-erro-ofsset
                               move ws-fs-arqRegistros                     to ws-msn-erro-cod
                               move "Erro ao gravar no arqRegistros!"      to ws-msn-erro-text
                               perform finaliza-anormal
                           end-if

                       end-if

               end-if

               end-if

           end-perform


           .
       cadastrar_notas-exit.
           exit.



      *>------------------------------------------------------------------------
      *>  Conferir se nota é até 10
      *>------------------------------------------------------------------------
       conferir-tamanho-notas section.


           *> parametro de adequação
           if ws-nota-01 >= 10,00 then
               move 0 to ws-nota-01
           end-if
           if ws-nota-02 >= 10,00 then
               move 0 to ws-nota-02
           end-if
           if ws-nota-03 >= 10,00 then
               move 0 to ws-nota-03
           end-if
           if ws-nota-04 >= 10,00 then
               move 0 to ws-nota-04
           end-if


           .
       conferir-tamanho-notas-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Consultar cadastro/situacao do aluno
      *>------------------------------------------------------------------------
       consulta-cadastro section.

           perform until ws-voltar-p-menu

           move space to ws-menu-principal
           move 0 to ws-cod-aluno
           move 0 to ws-media

           *>-- tela entrada codigo para consulta
           display sc-tela-consulta-cadastro
           accept  sc-tela-consulta-cadastro

           if ws-voltar-p-menu then *>tratamento: caso o usuario digite, ao mesmo tempo, o cod e "s" para voltar p menu, volta imediatamente p menu principal
               next sentence
           else
               move    ws-cod-aluno to fd-cod-aluno
               read arqRegistros

               if ws-fs-arqRegistros  <> 00 and ws-fs-arqRegistros <> 05 and ws-fs-arqRegistros <> 23 then
                   move 7                                  to ws-msn-erro-ofsset
                   move ws-fs-arqRegistros                 to ws-msn-erro-cod
                   move "Erro ao ler arqRegistros!"        to ws-msn-erro-text
                   perform finaliza-anormal

               else
                   if ws-fs-arqRegistros = 23 then *>não cadastro no codigo de entrada do usuario

                       move "Nao ha registros neste codigo!!" to ws-mensagem

                   else
                   if ws-fs-arqRegistros = 0 then

                       move space to ws-mensagem
                       move fd-registros-alunos to ws-registros-alunos

                       perform somar-notas

                       display sc-tela-dados-aluno
                       accept aux_erase

                   end-if
               end-if

           end-if

           .
       consulta-cadastro-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Somar notas
      *>------------------------------------------------------------------------
       somar-notas section.


           move 4 to ws-aux-div-notas *>quantidade de notas (4)
           move 0 to ws-soma-notas
           move 0 to ws-media

           *>-- somar notas
           compute ws-soma-notas =  ws-nota-01
                                  + ws-nota-02
                                  + ws-nota-03
                                  + ws-nota-04


           *>-- calculo da media
           compute ws-media = ws-soma-notas/ws-aux-div-notas
           if ws-media >= 6 then
               move "Aprovado" to ws-mensagem-sit
           else
               move "Reprovado" to ws-mensagem-sit
           end-if


           .
       somar-notas-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Consultar cadastro de forma sequencial (next)
      *>------------------------------------------------------------------------
       con-cadastro-sequencial section.

           close arqRegistros
           move 1 to       fd-cod-aluno
           move space to   ws-mensagem

           perform until   ws-sair-sit

               open i-o arqRegistros
               read arqRegistros next
               if  ws-fs-arqRegistros <> 0  then

                  if ws-fs-arqRegistros = 10 then

                      perform consultar-temp-sequencial-prev *>le o arquivo do primeiro registro até o ultimo

                  else
                      move 8                                                   to ws-msn-erro-ofsset
                      move ws-fs-arqRegistros                                  to ws-msn-erro-cod
                      move "Erro ao ler sequencialmente arqRegistros!"         to ws-msn-erro-text
                      perform finaliza-anormal
                  end-if

               end-if

               move  fd-registros-alunos       to  ws-registros-alunos
               move  space to ws-mensagem-enter

               perform somar-notas
               move "Deseja consultar mais um aluno (S/N)?" to ws-mensagem-02

               *>-- tela situacao aluno
               display sc-tela-dados-aluno-02
               accept  sc-tela-dados-aluno-02

           end-perform

           close arqRegistros
           open i-o arqRegistros


           .
       con-cadastro-sequencial-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Rotina de consulta de temperatura  - lê o arquivo de forma sequencial
      *>------------------------------------------------------------------------
       consultar-temp-sequencial-prev section.


           perform until ws-sair-sit

               read arqRegistros previous
               if  ws-fs-arqRegistros <> 0  then

                  if ws-fs-arqRegistros = 10 then

                      perform con-cadastro-sequencial *>le o arquivo de trás para frente

                  else
                      move 9                                                   to ws-msn-erro-ofsset
                      move ws-fs-arqRegistros                                  to ws-msn-erro-cod
                      move "Erro ao ler sequencialmente arqRegistros!"         to ws-msn-erro-text
                      perform finaliza-anormal

                  end-if

               end-if

               move  fd-registros-alunos       to  ws-registros-alunos
               move  space to ws-mensagem-enter

               perform somar-notas
               move "Deseja consultar mais um aluno (S/N)?" to ws-mensagem-02

               *>-- tela situacao aluno
               display sc-tela-dados-aluno-02
               accept  sc-tela-dados-aluno-02


           end-perform


           .
       consultar-temp-seq-prev-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Deletar Registro
      *>------------------------------------------------------------------------
       deletar-registro section.


           perform until ws-voltar-p-menu

               move space to ws-menu-principal
               move 0 to ws-cod-aluno

               *>-- entrada cod registro a ser deletado
               display sc-tela-deletar-aluno
               accept  sc-tela-deletar-aluno
               move space to ws-mensagem

               if ws-voltar-p-menu then *>tratamento: caso o usuario digite, ao mesmo tempo, o cod e "s" para voltar p menu, volta imediatamente p menu principal
                   next sentence
               else
                   move ws-cod-aluno to fd-cod-aluno
                   delete arqRegistros
                   move fd-cod-aluno to ws-cod-aluno

                   if  ws-fs-arqRegistros = 0 then

                       move "Cadastro apagado com sucesso!" to ws-mensagem

                   else
                       if ws-fs-arqRegistros = 23 then

                           move "Codigo invalido!" to ws-mensagem

                       else
                           move 10                                              to ws-msn-erro-ofsset
                           move ws-fs-arqRegistros                             to ws-msn-erro-cod
                           move "Erro ao apagar registro do arqRegistros!"     to ws-msn-erro-text
                           perform finaliza-anormal
                       end-if

                   end-if
               end-if

           end-perform
           .
       deletar-registro-exit.
           exit.



      *>------------------------------------------------------------------------
      *>  Alterar Dados do Arquivo
      *>------------------------------------------------------------------------
       alterar-dados section.


           perform until ws-voltar-p-menu

               move space to ws-menu-principal
               move 0 to ws-cod-aluno

               *>-- tela de entrada do cod a ser alterado
               display sc-tela-cod-alterar-dados
               accept  sc-tela-cod-alterar-dados
               move space to ws-mensagem

               if ws-voltar-p-menu then *>tratamento: caso o usuario digite, ao mesmo tempo, o cod e "s" para voltar p menu, volta imediatamente p menu principal
                   next sentence
               else
                   move    ws-cod-aluno to fd-cod-aluno
                   read arqRegistros

                   if ws-fs-arqRegistros  <> 00 and ws-fs-arqRegistros <> 05 and ws-fs-arqRegistros <> 23 then
                       move 11                                 to ws-msn-erro-ofsset
                       move ws-fs-arqRegistros                 to ws-msn-erro-cod
                       move "Erro ao ler arqRegistros!"        to ws-msn-erro-text
                       perform finaliza-anormal

                   else
                       if ws-fs-arqRegistros = 23 then *>não cadastro no codigo de entrada do usuario

                           move "Nao ha registros neste codigo!!" to ws-mensagem

                       else
                       if ws-fs-arqRegistros = 0 then

                           move space to ws-mensagem
                           move fd-registros-alunos to ws-registros-alunos

                           *>-- mostra e ler novamnete os dados que poderão ser editados
                           display sc-tela-alterar-dados
                           accept  sc-tela-alterar-dados

                           move  ws-registros-alunos to fd-registros-alunos
                           rewrite fd-registros-alunos

                           if ws-fs-arqRegistros  <> 00 then
                               move 12                                     to ws-msn-erro-ofsset
                               move ws-fs-arqRegistros                     to ws-msn-erro-cod
                               move "Erro ao gravar no arqRegistros!"      to ws-msn-erro-text
                               perform finaliza-anormal
                           end-if

                       end-if
                   end-if
               end-if
           end-perform

           .
       alterar-dados-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finaliza anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro.
           Stop run
           .
       finaliza-anormal-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finalizacao section.

           close arqRegistros
           if ws-fs-arqRegistros  <> 00 then
               move 13                                       to ws-msn-erro-ofsset
               move ws-fs-arqRegistros                       to ws-msn-erro-cod
               move "Erro finalizacao fo arqRegistros!"      to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           display
           erase
           display "           --- FIM ---"
           Stop run.

           .
       finalizacao-exit.
           exit.


