*&---------Developing Solutions off people, process and project's-------
* &
* & Author...........: Christopher Nicolas Mauricio .'.
* & Consultancy .....: DS3P
* & Date develop ....: 10.07.2019
* & Type of prg .....: Executable
* & Transaction .....: YDS3P_E001
*&----------------------------------------------------------------------

REPORT yds3p_command_server.

TABLES: rlgrap.

TYPES: BEGIN OF typ_file,
         file_name TYPE  rlgrap-filename,
       END OF typ_file.

DATA: lt_files TYPE STANDARD TABLE OF typ_file WITH HEADER LINE.
DATA: w_ans.

PARAMETERS:  p_dir LIKE rlgrap-filename DEFAULT ''.
SELECT-OPTIONS:  s_file FOR rlgrap-filename .

START-OF-SELECTION.

  LOOP AT s_file.
    CONCATENATE p_dir s_file-low INTO lt_files-file_name.
    CONDENSE lt_files-file_name NO-GAPS.
    APPEND lt_files.
  ENDLOOP.


  LOOP AT lt_files.

    OPEN DATASET lt_files-file_name FOR INPUT IN BINARY MODE.

    IF sy-subrc NE 0.

      CALL FUNCTION 'POPUP_CONTINUE_YES_NO'
        EXPORTING
          defaultoption = 'N'
          textline1     = 'Não existente... Deseja criar o arquivo no diretório para teste de execução ?'
          textline2     = lt_files-file_name
          titel         = 'ATENÇÃO APÓS CRIAR O ARQUIVO ESTE SERÁ APAGADO, APENAS TESTE NA AL11'
        IMPORTING
          answer        = w_ans
        EXCEPTIONS
          OTHERS        = 1.

      IF w_ans = 'J'.
        CLOSE DATASET lt_files-file_name.
        OPEN DATASET lt_files-file_name FOR OUTPUT IN BINARY MODE.
        CLOSE DATASET lt_files-file_name.
        clear w_ans.
      ELSE.
        EXIT.
      ENDIF.
      ENDIF.

OPEN DATASET lt_files-file_name FOR INPUT IN BINARY MODE.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'POPUP_CONTINUE_YES_NO'
        EXPORTING
          defaultoption = 'N'
          textline1     = 'Deseja realmente continual com o procedimento de delete ( apagar ) os arquivos'
          textline2     = lt_files-file_name
          titel         = 'ATENÇÃO ESTA PRESTES A APAGAR ARQUIVOS'
        IMPORTING
          answer        = w_ans
        EXCEPTIONS
          OTHERS        = 1.
     endif.

    CLOSE DATASET lt_files-file_name.
    CHECK w_ans = 'J'.

    DELETE DATASET lt_files-file_name.

    IF sy-subrc NE 0.
      MESSAGE e899(bd) WITH 'Arquivo não existente' lt_files-file_name.
      EXIT.
    ELSE.
      CLOSE DATASET lt_files-file_name.
    ENDIF.
  ENDLOOP.

  MESSAGE i899(bd) WITH 'Procedimento executado com exito'.