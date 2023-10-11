interface ZIF_ABAP_ALV
  public .


  data O_ALV type ref to CL_GUI_ALV_GRID .
  constants C_VARIANT_SAVE_ALL type CHAR1 value 'A' ##NO_TEXT.
  constants C_VARIANT_SAVE_DISABLED type CHAR1 value '' ##NO_TEXT.
  constants C_VARIANT_SAVE_USER type CHAR1 value 'U' ##NO_TEXT.
  constants C_VARIANT_SAVE_GLOBAL type CHAR1 value 'X' ##NO_TEXT.
  constants UC_GOTO type SY-UCOMM value 'GOTO' ##NO_TEXT.

  methods GET_STRUCTURE
    returning
      value(RV_STRUCTURE) type DD03L-TABNAME .
  methods GET_VARIANT
    returning
      value(RS_VARIANT) type DISVARIANT .
  methods GET_VARIANT_SAVE
    returning
      value(RV_SAVE_MODE) type CHAR1 .
  methods GET_LAYOUT
    returning
      value(RS_LAYOUT) type LVC_S_LAYO .
  methods GET_PRINT
    returning
      value(RS_PRINT) type LVC_S_PRNT .
  methods GET_FCAT
    returning
      value(RT_FCAT) type LVC_T_FCAT .
  methods GET_OUTTAB
    returning
      value(RO_TAB) type ref to DATA .
  methods GET_SORT
    returning
      value(RT_SORT) type LVC_T_SORT .
  methods GET_FILTER
    returning
      value(RT_FILTER) type LVC_T_FILT .
  methods GET_SGROUPS
    returning
      value(RT_GROUPS) type LVC_T_SGRP .
  methods GET_ICON_FIELDS
    returning
      value(RT_ICONS) type LVC_T_FCAT .
  methods GET_CHECKBOX_FIELDS
    returning
      value(RT_CHCBOX) type LVC_T_FCAT .
  methods GET_HOTSPOTS_FIELDS
    returning
      value(RT_HOTSPOT) type LVC_T_FCAT .
  methods GET_TOOLBAR_EXC
    returning
      value(RT_FUNCTION) type UI_FUNCTIONS .
  methods GET_HYPERLINKS
    returning
      value(RT_HYPERLINK) type LVC_T_HYPE .
  methods GET_QINFO
    returning
      value(RT_QINFO) type LVC_T_QINF .
  methods DISPLAY
    returning
      value(RO_SELF) type ref to ZIF_ABAP_ALV .
  methods SET_MODEL
    importing
      !IO_MODEL type ref to ZIF_ABAP_REPORT_MODEL .
  methods SET_SETTINGS
    importing
      !IO_SETTINGS type ref to ZIF_ABAP_ALV_SETTINGS .
  methods GET_SETTINGS
    returning
      value(RO_SETTINGS) type ref to ZIF_ABAP_ALV_SETTINGS .
  methods GET_QUAN_FIELDS
    returning
      value(RT_FCAT) type LVC_T_FCAT .
endinterface.
