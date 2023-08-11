interface ZIF_ABAP_REPORT_CONTROLLER
  public .


  data O_MODEL type ref to ZIF_ABAP_REPORT_MODEL read-only .
  data O_VIEW type ref to ZIF_ABAP_REPORT_VIEW read-only .

  methods GET_MODEL
    returning
      value(RO_MODEL) type ref to ZIF_ABAP_REPORT_MODEL .
  methods GET_VIEW
    returning
      value(RO_VIEW) type ref to ZIF_ABAP_REPORT_VIEW .
  methods EXECUTE_REPORT .
endinterface.
