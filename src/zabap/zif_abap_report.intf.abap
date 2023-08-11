interface ZIF_ABAP_REPORT
  public .


  data GUI_STATUS type GUI_STATUS .
  data GUI_TITLE type GUI_TITLE .
  constants UC_BACK type SY-UCOMM value 'BACK' ##NO_TEXT.
  constants UC_TOP type SY-UCOMM value 'TOP' ##NO_TEXT.
  constants UC_EXIT type SY-UCOMM value 'EXIT' ##NO_TEXT.
  constants UC_SHOW_LOG type SY-UCOMM value 'SHOW_LOG' ##NO_TEXT.
  constants UC_LOG_HIST type SY-UCOMM value 'LOG_HIST' ##NO_TEXT.

  methods RAISE_PBO .
  methods RAISE_UC
    importing
      !IV_UCOMM type SY-UCOMM .
endinterface.
