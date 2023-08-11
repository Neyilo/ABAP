interface ZIF_ABAPLOG
  public .


  data HANDLE type BALLOGHNDL read-only .
  data DB_NUMBER type BALOGNR read-only .
  data HEADER type BAL_S_LOG .
  constants C_INFORMATION type MSGTY value 'I' ##NO_TEXT.
  constants C_WARNING type MSGTY value 'W' ##NO_TEXT.
  constants C_SUCCESS type MSGTY value 'S' ##NO_TEXT.
  constants C_ABORT type MSGTY value 'A' ##NO_TEXT. "A' ##NO_TEXT.
  constants C_ERROR type MSGTY value 'E' ##NO_TEXT.

  methods INFORMATION
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY default 'I'
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods WARNING
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY default 'W'
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods ERROR
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY default 'E'
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods SUCCESS
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY default 'S'
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods ABORT
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY default 'A'
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods ADD
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY optional
      !IV_CONTEXT type SIMPLE optional
      !IV_CALLBACK_FM type CSEQUENCE optional
      !IV_IMPORTANCE type BALPROBCL optional
    preferred parameter IV_LOG
    returning
      value(RO_LOG) type ref to ZIF_ABAPLOG .
  methods HAS_WARNINGS
    returning
      value(RV_YES) type ABAP_BOOL .
  methods HAS_ERRORS
    returning
      value(RV_YES) type ABAP_BOOL .
  methods GET_SEVERITY
    returning
      value(RV_SEVERITY) type MSGTY .
  methods DISPLAY_POPUP .
  methods DISPLAY_FULLSCREEN .
  methods EXPORT_TO_TABLE
    returning
      value(ET_BAPIRET) type BAPIRETTAB .
  methods SAVE .
  methods IS_EMPTY
    returning
      value(RV_YES) type ABAP_BOOL .
  methods REFRESH .
  methods LENGTH
    returning
      value(RV_LENGTH) type I .
  methods SET_DEFAULT_SETTINGS
    changing
      !CS_BALLOG type BAL_S_LOG .
endinterface.
