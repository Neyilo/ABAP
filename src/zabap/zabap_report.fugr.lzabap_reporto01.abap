*----------------------------------------------------------------------*
***INCLUDE LZABAP_REPORTO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_0100 output.

  set pf-status go_report->gui_status.
  set titlebar  go_report->gui_title.

  go_report->raise_pbo( ).

endmodule.