interface ZIF_ABAP_ALV_EVENT_HANDLER
  public .


  interfaces IF_BADI_INTERFACE .

  methods HOTSPOT_CLICK
    importing
      !IS_ROW_ID type LVC_S_ROW optional
      !IS_COLUMN_ID type LVC_S_COL optional
      !IS_ROW_NO type LVC_S_ROID optional
    changing
      !CV_PREVENT_DEFAULT type XFELD optional .
endinterface.
