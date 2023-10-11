class ZCL_REPORT_CONTROLLER definition
  public
  create public .

public section.

  interfaces ZIF_ABAP_REPORT .
  interfaces ZIF_ABAP_REPORT_CONTROLLER .

  aliases GUI_STATUS
    for ZIF_ABAP_REPORT~GUI_STATUS .
  aliases GUI_TITLE
    for ZIF_ABAP_REPORT~GUI_TITLE .
  aliases EXECUTE_REPORT
    for ZIF_ABAP_REPORT_CONTROLLER~EXECUTE_REPORT .
  aliases GET_MODEL
    for ZIF_ABAP_REPORT_CONTROLLER~GET_MODEL .
  aliases GET_VIEW
    for ZIF_ABAP_REPORT_CONTROLLER~GET_VIEW .

  methods CONSTRUCTOR
    importing
      !IO_VIEW type ref to ZIF_ABAP_REPORT_VIEW
      !IO_MODEL type ref to ZIF_ABAP_REPORT_MODEL .
protected section.

  aliases O_MODEL
    for ZIF_ABAP_REPORT_CONTROLLER~O_MODEL .
  aliases O_VIEW
    for ZIF_ABAP_REPORT_CONTROLLER~O_VIEW .
  aliases UC_BACK
    for ZIF_ABAP_REPORT~UC_BACK .
  aliases UC_EXIT
    for ZIF_ABAP_REPORT~UC_EXIT .
  aliases UC_LOG_HIST
    for ZIF_ABAP_REPORT~UC_LOG_HIST .
  aliases UC_SHOW_LOG
    for ZIF_ABAP_REPORT~UC_SHOW_LOG .
  aliases UC_TOP
    for ZIF_ABAP_REPORT~UC_TOP .

  data MO_ALV_FULLSCREEN type ref to ZIF_ABAP_ALV .
private section.
ENDCLASS.



CLASS ZCL_REPORT_CONTROLLER IMPLEMENTATION.


  method CONSTRUCTOR.

    gui_status = 'ALV_GUI'.
    gui_title  = 'ALV_TITLE'.

    o_model ?= io_model.
    o_view  ?= io_view.

  endmethod.


  method execute_report.

    call function 'ZABAP_REPORT_VIEW'
      exporting
        io_report = me.

  endmethod.


  method ZIF_ABAP_REPORT_CONTROLLER~GET_MODEL.
    ro_model = o_model.
  endmethod.


  method zif_abap_report~raise_pbo.

    if mo_alv_fullscreen is not bound.

      data(lo_base_container) = new cl_gui_custom_container( container_name = 'BASE_CONTAINER' ).

      mo_alv_fullscreen = new zcl_abap_alv( io_parent = lo_base_container ).
      mo_alv_fullscreen->set_model( me->o_model ).
      mo_alv_fullscreen->display( ).

    else.
      mo_alv_fullscreen->o_alv->refresh_table_display(
        exporting
          is_stable      = value lvc_s_stbl( col = abap_true row = abap_true )
          i_soft_refresh = abap_true
        exceptions
          finished       = 1
          others         = 2 ).
      if sy-subrc <> 0.

      endif.


    endif.

  endmethod.


  method ZIF_ABAP_REPORT~RAISE_UC.

    case iv_ucomm.

      when uc_back.
        leave to screen 0.
      when uc_top.
        leave to screen 0.
      when uc_exit.
        leave to screen 0.
      when uc_show_log.

      when uc_log_hist.

    endcase.

  endmethod.
ENDCLASS.
