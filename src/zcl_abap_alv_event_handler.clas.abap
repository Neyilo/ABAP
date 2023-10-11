class ZCL_ABAP_ALV_EVENT_HANDLER definition
  public
  create public .

public section.

  methods ON_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO
      !SENDER .
  methods ON_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM
      !SENDER  .
  methods ON_AFTER_USER_COMMAND
    for event AFTER_USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM
      !E_SAVED
      !E_NOT_PROCESSED
      !SENDER .
  methods ON_BEFORE_USER_COMMAND
    for event BEFORE_USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM
      !SENDER .
  methods ON_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE
      !SENDER.
  methods ON_F1
    for event ONF1 of CL_GUI_ALV_GRID
    importing
      !E_FIELDNAME
      !ES_ROW_NO
      !ER_EVENT_DATA
      !SENDER.
  methods ON_F4
    for event ONF4 of CL_GUI_ALV_GRID
    importing
      !E_FIELDNAME
      !E_FIELDVALUE
      !ES_ROW_NO
      !ER_EVENT_DATA
      !ET_BAD_CELLS
      !E_DISPLAY
      !SENDER.
  methods ON_DATA_CHANGED
    for event DATA_CHANGED of CL_GUI_ALV_GRID
    importing
      !ER_DATA_CHANGED
      !E_ONF4
      !E_ONF4_BEFORE
      !E_ONF4_AFTER
      !E_UCOMM
      !SENDER.
  methods ON_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO
      !SENDER.
  methods ON_DELAYED_CALLBACK
    for event DELAYED_CALLBACK of CL_GUI_ALV_GRID
    importing
      !SENDER..
  methods ON_DELAYED_CHANGED_SEL_CBCK
    for event DELAYED_CHANGED_SEL_CALLBACK of CL_GUI_ALV_GRID
    importing
      !SENDER .
  methods ON_CONTEXT_MENU_REQUEST
    for event CONTEXT_MENU_REQUEST of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !SENDER.
  methods ON_MENU_BUTTON
    for event MENU_BUTTON of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_UCOMM
      !SENDER .
  methods ON_AFTER_REFRESH
    for event AFTER_REFRESH of CL_GUI_ALV_GRID .
  methods ON_BUTTON_CLICK
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !ES_COL_ID
      !ES_ROW_NO
      !SENDER.
  methods ON_DATA_CHANGED_FINISHED
    for event DATA_CHANGED_FINISHED of CL_GUI_ALV_GRID
    importing
      !E_MODIFIED
      !ET_GOOD_CELLS
      !SENDER.
  methods ON_DROP_EXTERNAL_FILES
    for event DROP_EXTERNAL_FILES of CL_GUI_ALV_GRID
    importing
      !FILES
      !SENDER.
  methods ON_END_OF_LIST
    for event END_OF_LIST of CL_GUI_ALV_GRID
    importing
      !E_DYNDOC_ID
      !SENDER.
  methods ON_TOP_OF_PAGE
    for event TOP_OF_PAGE of CL_GUI_ALV_GRID
    importing
      !E_DYNDOC_ID
      !TABLE_INDEX
      !SENDER.
  methods ON_PRINT_TOP_OF_PAGE
    for event PRINT_TOP_OF_PAGE of CL_GUI_ALV_GRID
    importing
      !TABLE_INDEX
      !SENDER.
  methods ON_PRINT_TOP_OF_LIST
    for event PRINT_TOP_OF_LIST of CL_GUI_ALV_GRID
    importing
      !SENDER.
  methods ON_PRINT_END_OF_PAGE
    for event PRINT_END_OF_PAGE of CL_GUI_ALV_GRID
     importing
      !SENDER.
  methods ON_PRINT_END_OF_LIST
    for event PRINT_END_OF_LIST of CL_GUI_ALV_GRID
     importing
      !SENDER.
  methods CONSTRUCTOR .
  protected section.
private section.

  data MO_EVENT_HANDLER_BADI type ref to ZEX_ALV_EVENT_HANDLER .
ENDCLASS.



CLASS ZCL_ABAP_ALV_EVENT_HANDLER IMPLEMENTATION.


  method constructor.

    try.
        get badi mo_event_handler_badi
          filters
            program_name = sy-cprog.

      catch cx_root.

    endtry.

  endmethod.


  method on_after_refresh.
  endmethod.


  method on_after_user_command.
  endmethod.


  method on_before_user_command.
  endmethod.


  method on_button_click.
  endmethod.


  method on_context_menu_request.


  endmethod.


  method on_data_changed.
  endmethod.


  method on_data_changed_finished.
  endmethod.


  method on_delayed_callback.
  endmethod.


  method on_delayed_changed_sel_cbck.

    data: lo_alv type ref to cl_gui_alv_grid.

    lo_alv ?= sender.

    lo_alv->get_frontend_layout(
      importing
        es_layout = data(frontend_layout)
    ).

    lo_alv->get_selected_rows(
      importing
        et_index_rows = data(rows)
        et_row_no     = data(rows_no)
    ).

    frontend_layout-grid_title = |Testowa ALV-ka. Zaznaczono { lines( rows_no ) }|.

    lo_alv->set_frontend_layout( is_layout = frontend_layout ).

  endmethod.


  method on_double_click.
  endmethod.


  method on_drop_external_files.

    break gdziezyk.

    data: file_header type xstring,
          file_length type i,
          file_binary type solix_tab.

    data: lo_excel_ref TYPE REF TO cl_fdt_xl_spreadsheet.

    call function 'GUI_UPLOAD'
      exporting
        filename                = files
        filetype                = 'BIN'
      importing
        filelength              = file_length
        header                  = file_header
      tables
        data_tab                = file_binary
      exceptions
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        others                  = 17.

    check sy-subrc = 0.


    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = file_length
      IMPORTING
        buffer       = file_header
      TABLES
        binary_tab   = file_binary
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.

    try .
        lo_excel_ref = new cl_fdt_xl_spreadsheet(
                                document_name = files
                                xdocument     = file_header ) .
      catch cx_fdt_excel_core into data(lo_excp).
    endtry.

    lo_excel_ref->if_fdt_doc_spreadsheet~get_worksheet_names(
        IMPORTING
          worksheet_names = DATA(lt_worksheets) ).

    return.

    break gdziezyk.

    do.

      if 1 = 2.
        exit.
      endif.
    enddo.

  endmethod.


  method on_end_of_list.
  endmethod.


  method on_f1.
  endmethod.


  method on_f4.
  endmethod.


  method on_hotspot_click.

    try.
        data: prevent_default type abap_bool.

        call badi mo_event_handler_badi->hotspot_click
          exporting
            is_row_id          = e_row_id
            is_column_id       = e_column_id
            is_row_no          = es_row_no
          changing
            cv_prevent_default = prevent_default.

        check prevent_default = abap_false.

      catch cx_sy_ref_is_initial.

    endtry.

  endmethod.


  method on_menu_button.

    data: lo_outtab type ref to data.
    data: lo_alv type ref to zcl_abap_alv.

    field-symbols: <outtab_data> type any table.

    lo_alv ?= sender.
    lo_alv->get_selected_rows(
      importing
        et_index_rows = data(index_rows)
        et_row_no     = data(rows_no) ).

    case e_ucomm.

      when zif_abap_alv=>uc_goto.

        if lines( rows_no ) = 1.
          lo_outtab = lo_alv->get_outtab( ).
          assign lo_outtab->* to <outtab_data>.
          loop at <outtab_data> assigning field-symbol(<selected_line>).
          endloop.
        endif.

        loop at lo_alv->get_hotspots_fields( ) reference into data(lo_hotspot).

          if <selected_line> is assigned.
             assign component lo_hotspot->fieldname of structure <selected_line> to field-symbol(<hotspot_value>).
          endif.

          call method e_object->add_function
            exporting
              fcode    = conv #( |CALL_{ lo_hotspot->fieldname }| )
              text     = conv #( |Dsplay { lo_hotspot->scrtext_m }| )
              disabled = xsdbool( lines( rows_no ) <> 1 or <hotspot_value> is initial ).

          unassign <hotspot_value>.

        endloop.

        unassign <selected_line>.

    endcase.

  endmethod.


  method on_print_end_of_list.
  endmethod.


  method on_print_end_of_page.
  endmethod.


  method on_print_top_of_list.
  endmethod.


  method on_print_top_of_page.
  endmethod.


  method on_toolbar.

    append initial line to  e_object->mt_toolbar assigning field-symbol(<tlb_btn>).
    <tlb_btn>-butn_type  = 3.


    append initial line to  e_object->mt_toolbar assigning <tlb_btn>.
    <tlb_btn>-function   = zif_abap_alv=>uc_goto.
    <tlb_btn>-butn_type  = cntb_btype_dropdown.
    <tlb_btn>-icon       = icon_set_b.


  endmethod.


  method on_top_of_page.
  endmethod.


  method on_user_command.
  endmethod.
ENDCLASS.
