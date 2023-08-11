interface zif_abap_alv_settings
  public .

  types: begin of ty_event_sett,
           set_all                  type abap_bool,
           hotspot_click            type abap_bool,
           user_command             type abap_bool,
           after_user_command       type abap_bool,
           before_user_command      type abap_bool,
           toolbar                  type abap_bool,
           f1                       type abap_bool,
           f4                       type abap_bool,
           data_changed             type abap_bool,
           double_click             type abap_bool,
           delayed_callback         type abap_bool,
           delayed_changed_sel_cbck type abap_bool,
           context_menu_request     type abap_bool,
           menu_button              type abap_bool,
           after_refresh            type abap_bool,
           buttclick                type abap_bool,
           data_changed_finished    type abap_bool,
           drop_external_files      type abap_bool,
           end_of_list              type abap_bool,
           top_of_page              type abap_bool,
           print_top_of_page        type abap_bool,
           print_top_of_list        type abap_bool,
           print_end_of_page        type abap_bool,
           print_end_of_list        type abap_bool,
         end of ty_event_sett.

  types: begin of ty_hotspot,
           fieldname type string,
           domname   type string,
           priority  type string,
           active    type abap_bool,
           erp       type abap_bool,
           ewm       type abap_bool,
         end of ty_hotspot.

  types: tty_hotspot type hashed table of ty_hotspot with unique key fieldname domname.

  types: begin of ty_function,
           name      type string,
           selection type abap_bool,
         end of ty_function.


  types: begin of ty_settings,
           event_settings  type ty_event_sett,
           layout_settings type lvc_s_layo,
           filter          type LVC_T_FILT,
           sort            type lvc_t_sort,
           print           type LVC_S_PRNT,
           toolbar_cfunc   type ui_functions,
           toolbar_efunc   type ui_functions,
         end of ty_settings.

  methods get_toolbar_functions .
  methods get_extend_outtab .
  methods get_events .
endinterface.
