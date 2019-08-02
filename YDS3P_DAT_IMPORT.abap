*&---------Developing Solutions off people, process and project's-------
* &
* & Author...........: Christopher Nicolas Mauricio .'.
* & Consultancy .....: DS3P
* & Date develop ....: 10.07.2019
* & Type of prg .....: Executable
* & Transaction .....: YDS3P_E002
*&----------------------------------------------------------------------
REPORT YDS3P_DAT_IMPORT.

TYPES: BEGIN OF typ_arquivo,
        coluna_01  TYPE c LENGTH 255,
        coluna_02  TYPE c LENGTH 255,
        coluna_03  TYPE c LENGTH 255,
        coluna_04  TYPE c LENGTH 255,
        coluna_05  TYPE c LENGTH 255,
        coluna_06  TYPE c LENGTH 255,
        coluna_07  TYPE c LENGTH 255,
        coluna_08  TYPE c LENGTH 255,
        coluna_09  TYPE c LENGTH 255,
        coluna_10  TYPE c LENGTH 255,
        coluna_11  TYPE c LENGTH 255,
        coluna_12  TYPE c LENGTH 255,
        coluna_13  TYPE c LENGTH 255,
        coluna_14  TYPE c LENGTH 255,
        coluna_15  TYPE c LENGTH 255,
        coluna_16  TYPE c LENGTH 255,
        coluna_17  TYPE c LENGTH 255,
        coluna_18  TYPE c LENGTH 255,
        coluna_19  TYPE c LENGTH 255,
        coluna_20  TYPE c LENGTH 255,
        coluna_21  TYPE c LENGTH 255,
        coluna_22  TYPE c LENGTH 255,
        coluna_23  TYPE c LENGTH 255,
        coluna_24  TYPE c LENGTH 255,
        coluna_25  TYPE c LENGTH 255,
        coluna_26  TYPE c LENGTH 255,
        coluna_27  TYPE c LENGTH 255,
        coluna_28  TYPE c LENGTH 255,
        coluna_29  TYPE c LENGTH 255,
        coluna_30  TYPE c LENGTH 255,
      END OF typ_arquivo.


DATA: lt_arquivo TYPE STANDARD TABLE OF typ_arquivo ,
      ls_arquivo TYPE typ_arquivo .

DATA: lv_arquivo TYPE string.

DATA: lt_raw TYPE truxs_t_text_data.
DATA: lt_arquivos TYPE filetable,
      ls_arquivos TYPE file_table.

DATA: lv_rc TYPE i.


SELECTION-SCREEN BEGIN OF BLOCK blk_par WITH FRAME.

PARAMETERS: p_path  TYPE rlgrap-filename
           DEFAULT 'C:\temp\yds3p.dat' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blk_par.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.

*&----------------------------------------------------------------------
*&  Inicio da seleção e regras para o arquivo
*&----------------------------------------------------------------------

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Selecione o arquivo A importado!'
      file_filter             = 'Arquivos (*.txt *.dat *.DAT) |*.txt;*.dat;*.DAT|'
    CHANGING
      file_table              = lt_arquivos
      rc                      = lv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF sy-subrc EQ 0.
    READ TABLE lt_arquivos INTO ls_arquivos INDEX 1.

    IF sy-subrc EQ 0.
      p_path = ls_arquivos-filename.
    ENDIF.

    lv_arquivo = p_path.
  ENDIF.
*&----------------------------------------------------------------------
*&  Final da seleção e regras para o arquivo
*&----------------------------------------------------------------------

START-OF-SELECTION.

  lv_arquivo = p_path.
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename = lv_arquivo
    CHANGING
      data_tab = lt_raw
    EXCEPTIONS
      OTHERS   = 1.

  CHECK sy-subrc EQ 0.

  CALL FUNCTION 'TEXT_CONVERT_TEX_TO_SAP'
    EXPORTING
      i_field_seperator    = '|'
      i_tab_raw_data       = lt_raw
    TABLES
      i_tab_converted_data = lt_arquivo
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  LOOP AT lt_arquivo INTO ls_arquivo.

    CASE ls_arquivo-coluna_02.
      WHEN '0000'.
    ENDCASE.
  ENDLOOP.