class ZCL_ABAP_REPORT_MODEL definition
  public
  create public .

public section.

  interfaces ZIF_ABAP_REPORT_MODEL .

  aliases GET_MODEL
    for ZIF_ABAP_REPORT_MODEL~GET_MODEL .

  methods CONSTRUCTOR
    importing
      !IO_SELECTION type ref to ZIF_ABAP_SELECTION .
  methods QUERY .
protected section.

  types:
    begin of ty_model,
         name type model,
         data type ref to data,
         end of ty_model .
  types:
    tty_model type hashed table of ty_model with unique key name .

  data MT_MODEL type TTY_MODEL .
  data MO_SELECTION type ref to ZIF_ABAP_SELECTION .
  data MTR_MATNR type RSELOPTION .
  data MTR_LGNUM type RSELOPTION .
  data MTR_TANUM type RSELOPTION .

  methods SET_SELECTION_INTERNAL .
private section.
ENDCLASS.



CLASS ZCL_ABAP_REPORT_MODEL IMPLEMENTATION.


  method CONSTRUCTOR.
    mo_selection = io_selection.

    set_selection_internal( ).

    query( ).

  endmethod.


  method QUERY.

    FIELD-SYMBOLS: <test_data> type any table.

    data: test2 type ty_model,
          lo_table_type type ref to cl_abap_tabledescr.

    select * from
      /scwm/ordim_c
      into table @data(test)
        where lgnum in @mtr_lgnum and
              tanum in @mtr_tanum.

    lo_table_type ?= cl_abap_typedescr=>describe_by_data( p_data = test ).

    create data test2-data type handle lo_table_type.
    assign test2-data->* to <test_data>.
    <test_data> = test.

    insert test2 into table mt_model.

  endmethod.


  method SET_SELECTION_INTERNAL.

    field-symbols:
      <any_so> type any table.

    loop at mo_selection->get_selection_data( ) into data(selection_data).

      assign (selection_data-name) to <any_so>.
      check <any_so> is assigned.

      <any_so> = corresponding #( selection_data-so ).

      unassign <any_so>.

    endloop.

  endmethod.


  method ZIF_ABAP_REPORT_MODEL~GET_MODEL.

    read table mt_model with key name = iv_model_name reference into data(lo_data).

    ro_model = lo_data->data.

  endmethod.
ENDCLASS.
