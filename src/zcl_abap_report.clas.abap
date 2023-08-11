class ZCL_ABAP_REPORT definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_CONTROLLER type ref to ZIF_ABAP_REPORT_CONTROLLER .
protected section.

  data MO_CONTROLLER type ref to ZIF_ABAP_REPORT_CONTROLLER .
private section.
ENDCLASS.



CLASS ZCL_ABAP_REPORT IMPLEMENTATION.


  method CONSTRUCTOR.

    mo_controller ?= io_controller.

    mo_controller->execute_report( ).

  endmethod.
ENDCLASS.
