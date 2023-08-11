FUNCTION ZABAP_REPORT_VIEW.
*"----------------------------------------------------------------------
*"*"Lokalny interfejs:
*"  IMPORTING
*"     VALUE(IV_SCREEN) TYPE  SY-DYNNR DEFAULT '0100'
*"     VALUE(IO_REPORT) TYPE REF TO  ZIF_ABAP_REPORT OPTIONAL
*"----------------------------------------------------------------------

  go_report ?= io_report.
  call screen iv_screen.

ENDFUNCTION.
