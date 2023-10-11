class ZCL_ABAP_ALV_SETTINGS_DFLT definition
  public
  create public .

public section.

  interfaces ZIF_ABAP_ALV_SETTINGS .

  aliases GET_EVENTS
    for ZIF_ABAP_ALV_SETTINGS~GET_EVENTS .
  aliases GET_EXTEND_OUTTAB
    for ZIF_ABAP_ALV_SETTINGS~GET_EXTEND_OUTTAB .
  aliases GET_TOOLBAR_FUNCTIONS
    for ZIF_ABAP_ALV_SETTINGS~GET_TOOLBAR_FUNCTIONS .

  methods CONSTRUCTOR .
protected section.

  data MS_SETTINGS type ZIF_ABAP_ALV_SETTINGS~TY_SETTINGS .
private section.
ENDCLASS.



CLASS ZCL_ABAP_ALV_SETTINGS_DFLT IMPLEMENTATION.


  method CONSTRUCTOR.

    ms_settings-layout_settings-zebra      = abap_true.
    ms_settings-layout_settings-col_opt    = abap_true.
    ms_settings-layout_settings-cwidth_opt = abap_true.
    ms_settings-layout_settings-edit       = abap_false.
    ms_settings-layout_settings-edit_mode  = abap_false.
    ms_settings-layout_settings-sgl_clk_hd = abap_true.
    ms_settings-layout_settings-grid_title = 'Test'.

    ms_settings-event_settings-delayed_changed_sel_cbck = abap_true.
    ms_settings-event_settings-hotspot_click            = abap_true.
    ms_settings-event_settings-menu_button              = abap_true.
    ms_settings-event_settings-toolbar                  = abap_true.
    ms_settings-event_settings-user_command             = abap_true.

    append initial line to ms_settings-toolbar_cfunc assigning field-symbol(<custom_function>).
*    <custom_function>

  endmethod.


  method ZIF_ABAP_ALV_SETTINGS~GET_EVENTS.
  endmethod.


  method ZIF_ABAP_ALV_SETTINGS~GET_EXTEND_OUTTAB.
  endmethod.


  method ZIF_ABAP_ALV_SETTINGS~GET_TOOLBAR_FUNCTIONS.
  endmethod.
ENDCLASS.
