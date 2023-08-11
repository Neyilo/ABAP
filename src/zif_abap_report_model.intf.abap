interface ZIF_ABAP_REPORT_MODEL
  public .


  methods GET_MODEL
    importing
      !IV_MODEL_NAME type STRING optional
    returning
      value(RO_MODEL) type ref to DATA .
endinterface.
