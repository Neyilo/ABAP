class ZCL_ABAP_SELECTION definition
  public
  create public .

public section.

  interfaces ZIF_ABAP_SELECTION .

  aliases C_SELECTION_P
    for ZIF_ABAP_SELECTION~C_SELECTION_P .
  aliases C_SELECTION_SO
    for ZIF_ABAP_SELECTION~C_SELECTION_SO .
  aliases GET_SELECTION_DATA
    for ZIF_ABAP_SELECTION~GET_SELECTION_DATA .

  methods CONSTRUCTOR .
protected section.

  aliases TTY_SELECTION
    for ZIF_ABAP_SELECTION~TTY_SELECTION .
  aliases TY_SELECTION
    for ZIF_ABAP_SELECTION~TY_SELECTION .

  data MT_SELECTION type TTY_SELECTION .
private section.

  methods BUILD_SELECTION_TABLE .
ENDCLASS.



CLASS ZCL_ABAP_SELECTION IMPLEMENTATION.


  method build_selection_table.

    data: selection_data type table of rsparams,
          selection_name type string,
          selection_line like line of mt_selection.

    call function 'RS_REFRESH_FROM_SELECTOPTIONS'
      exporting
        curr_report     = sy-cprog
      tables
        selection_table = selection_data
      exceptions
        not_found       = 1
        no_report       = 2
        others          = 3.
    if sy-subrc <> 0.

    endif.

    loop at selection_data reference into data(lo_selection).

      selection_name = lo_selection->selname.


      case lo_selection->kind.
        when c_selection_so.
          check lo_selection->sign is not initial.
          replace 'S_' in selection_name with 'MTR_'.
        when c_selection_p.
          replace 'P_' in selection_name with 'MV_'.
      endcase.

      read table mt_selection assigning field-symbol(<selection>) with key name = selection_name type = lo_selection->kind.

      if <selection> is assigned.
        append initial line to selection_line-so assigning field-symbol(<so_value>).
        <so_value> = corresponding #( lo_selection->* ).
      else.
        selection_line-name = selection_name.
        selection_line-type = lo_selection->kind.

        case lo_selection->kind.
          when c_selection_so.
            append initial line to selection_line-so assigning <so_value>.
            <so_value> = corresponding #( lo_selection->* ).
          when c_selection_p.
            selection_line-value = lo_selection->low.
            append initial line to selection_line-so assigning <so_value>.
            <so_value>-low    = <so_value>-high = lo_selection->low.
            <so_value>-option = zif_abap_c=>c_option_eq.
            <so_value>-sign   = zif_abap_c=>c_sign_inc.
        endcase.

        insert selection_line into table mt_selection.

      endif.

      unassign <selection>.

    endloop.

  endmethod.


  method CONSTRUCTOR.
    build_selection_table( ).
  endmethod.


  method zif_abap_selection~get_selection_data.

    rt_selection = mt_selection.

  endmethod.
ENDCLASS.
