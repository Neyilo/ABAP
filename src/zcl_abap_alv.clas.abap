class ZCL_ABAP_ALV definition
  public
  inheriting from CL_GUI_ALV_GRID
  create public

  global friends CL_GUI_ALV_GRID .

public section.

  interfaces ZIF_ABAP_ALV .
  interfaces IF_ALV_RM_GRID_FRIEND .

  aliases DISPLAY
    for ZIF_ABAP_ALV~DISPLAY .
  aliases GET_CHECKBOX_FIELDS
    for ZIF_ABAP_ALV~GET_CHECKBOX_FIELDS .
  aliases GET_FCAT
    for ZIF_ABAP_ALV~GET_FCAT .
  aliases GET_FILTER
    for ZIF_ABAP_ALV~GET_FILTER .
  aliases GET_HOTSPOTS_FIELDS
    for ZIF_ABAP_ALV~GET_HOTSPOTS_FIELDS .
  aliases GET_HYPERLINKS
    for ZIF_ABAP_ALV~GET_HYPERLINKS .
  aliases GET_ICON_FIELDS
    for ZIF_ABAP_ALV~GET_ICON_FIELDS .
  aliases GET_LAYOUT
    for ZIF_ABAP_ALV~GET_LAYOUT .
  aliases GET_OUTTAB
    for ZIF_ABAP_ALV~GET_OUTTAB .
  aliases GET_PRINT
    for ZIF_ABAP_ALV~GET_PRINT .
  aliases GET_QINFO
    for ZIF_ABAP_ALV~GET_QINFO .
  aliases GET_SGROUPS
    for ZIF_ABAP_ALV~GET_SGROUPS .
  aliases GET_SORT
    for ZIF_ABAP_ALV~GET_SORT .
  aliases GET_STRUCTURE
    for ZIF_ABAP_ALV~GET_STRUCTURE .
  aliases GET_TOOLBAR_EXC
    for ZIF_ABAP_ALV~GET_TOOLBAR_EXC .
  aliases GET_VARIANT_ALV
    for ZIF_ABAP_ALV~GET_VARIANT .
  aliases GET_VARIANT_SAVE
    for ZIF_ABAP_ALV~GET_VARIANT_SAVE .

  types:
    begin of ty_domain_c,
         domname    type string,
         field      type string,
         field_d    type string,
         table      type string,
         txt_table  type string,
         fix_values type string,
         end of ty_domain_c .
  types:
    tty_domain_c type standard table of ty_domain_c with empty key .
  types:
    begin of ty_domain,
         domname type string,
         field   type string,
         name    type string,
         value   type string,
         text    type dd07t-ddtext,
         end of ty_domain .
  types:
    tty_domain type hashed table of ty_domain with unique key domname value .

  data C_XFELD_DOMAIN type STRING value 'XFELD' ##NO_TEXT.
  data C_ICON_DOMAIN type STRING value 'ICON' ##NO_TEXT.
  data C_DATUM_DOMAIN type STRING value 'DATUM' ##NO_TEXT.
  data C_TIME_DOMAIN type STRING value 'TIME' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IO_ALV type ref to CL_GUI_ALV_GRID optional
      !IV_SHELLSTYLE type I default 0
      !IV_LIFETIME type I optional
      !IO_PARENT type ref to CL_GUI_CONTAINER optional
      !IV_APPL_EVENTS type CHAR01 default SPACE
      !IO_PARENTDBG type ref to CL_GUI_CONTAINER optional
      !IO_APPLOGPARENT type ref to CL_GUI_CONTAINER optional
      !IO_GRAPHICSPARENT type ref to CL_GUI_CONTAINER optional
      !IV_NAME type STRING optional
      !IV_FCAT_COMPLETE type SAP_BOOL default SPACE
      !IO_PREVIOUS_SRAL_HANDLER type ref to IF_SALV_GUI_SRAL_HANDLER optional .
  class-methods CREATE_ICON_WITH_TEXT
    importing
      !IV_ICON type ICON
      !IV_ICON_TEXT type CHAR40
      !IV_ICON_QINFO type CHAR40
    returning
      value(RV_ICON) type CHAR30 .
protected section.

  aliases O_ALV
    for ZIF_ABAP_ALV~O_ALV .

  data MO_DATA type ref to DATA .
  data MT_FCAT type LVC_T_FCAT .
  data MT_DOMAIN_VAL type TTY_DOMAIN .
  data MT_DOMAIN_C type TTY_DOMAIN_C .
  data MO_ALV type ref to CL_GUI_ALV_GRID .

  methods EXTEND_OUTTAB
    changing
      !CO_DATA type ref to DATA
    returning
      value(RO_DATA) type ref to DATA .
  methods CREATE_ICON_FCAT
    importing
      !IV_FIELDNAME type LVC_S_FCAT-FIELDNAME
      !IV_TEXT type STRING
    returning
      value(RS_FCAT) type LVC_S_FCAT .
  methods CREATE_HOTSPOT_FCAT
    changing
      value(CS_FCAT) type LVC_S_FCAT .
  methods CREATE_ICON_WITHTEXT_FCAT
    importing
      !IV_FIELDNAME type LVC_S_FCAT-FIELDNAME
      !IV_TEXT type STRING
    returning
      value(RS_FCAT) type LVC_S_FCAT .
private section.

  types:
    TTY_MARA type table of /SCWM/ORDIM_C .

  data MARA type TTY_MARA .
  data MO_MODEL type ref to ZIF_ABAP_REPORT_MODEL .
  data MO_DATA_MODEL type ref to DATA .
  data MO_ALV_SETTINGS type ref to ZIF_ABAP_ALV_SETTINGS .

  methods CREATE_DYNAMIC_TABLE
    returning
      value(RO_DATA) type ref to DATA .
  methods BUILD_FCAT .
ENDCLASS.



CLASS ZCL_ABAP_ALV IMPLEMENTATION.


  method build_fcat.

    data:
      tr_domanme    type range of dd01l-domname,
      tr_domanme_fv type range of dd01l-domname.

    data: lo_struc type ref to cl_abap_structdescr.

    data: fieldcat_temp type lvc_t_fcat.

    data: domain_data type dd01v,
          d_tab_a     type table of dd07v,
          d_tab_n     type table of dd07v.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name       = '/SCWM/ORDIM_C'
      changing
        ct_fieldcat            = mt_fcat
      exceptions
        inconsistent_interface = 1
        program_error          = 2
        others                 = 3.
    if sy-subrc <> 0.

    endif.

    append initial line to fieldcat_temp assigning field-symbol(<mode_icon_fc>).
    <mode_icon_fc>-fieldname = c_icon_domain.
    <mode_icon_fc>-domname   = c_icon_domain.
*    <mode_icon_fc>-domname   = 'CHAR30'.
*    <mode_icon_fc>-outputlen = '000030'.
*    <mode_icon_fc>-intlen    = '000060'.
*    <mode_icon_fc>-dd_outlen = '000060'.
    <mode_icon_fc>-col_pos   = 1.
    <mode_icon_fc>-scrtext_s = 'Tryb'.
    <mode_icon_fc>-scrtext_m = 'Tryb zmiany'.
    <mode_icon_fc>-scrtext_l = 'Tryb zmiany'.
    <mode_icon_fc>-col_opt   = abap_true.
    <mode_icon_fc>-just      = 'C'.


    loop at mt_fcat reference into data(lo_fcat) where tech = abap_false.

      if lo_fcat->datatype = 'RAW' and lo_fcat->convexit is initial.
        lo_fcat->tech = abap_true.
      endif.



      if lo_fcat->intlen <= 8.
        lo_fcat->just      = 'C'.
      endif.

      if lo_fcat->domname  = c_xfeld_domain.
        lo_fcat->checkbox = abap_true.
        continue.
      endif.

      if lo_fcat->domname  = c_icon_domain.
        lo_fcat->icon      = abap_true.
        lo_fcat->just      = 'C'.
        continue.
      endif.

      check lo_fcat->domname is not initial.
      check lo_fcat->domname <> c_datum_domain.
      check lo_fcat->domname <> c_time_domain.

      insert value #( low    = lo_fcat->domname
                      sign   = zif_abap_c=>c_sign_inc
                      option = zif_abap_c=>c_option_eq )
      into table tr_domanme.

    endloop.

    if tr_domanme is not initial.
      "Get all domain configuration
      select domname, entitytab, valexi as fix_values, dl~tabname as txt_table
        from
         dd01vv
        left outer join dd08l as dl on dl~checktable = dd01vv~entitytab and dl~frkart = 'TEXT'
        into table @data(domain_config)
         where dd01vv~as4local = 'A'          and
               dd01vv~domname  in @tr_domanme and
               ( dd01vv~entitytab <> '' or dd01vv~valexi = @abap_true ).

      loop at domain_config into data(dconfig).
        if dconfig-entitytab is not initial and dconfig-txt_table is initial.
          delete domain_config.
        endif.
      endloop.

      tr_domanme_fv = value #( for domname in domain_config where ( fix_values = abap_true ) ( low    = domname-domname
                                                                                               sign   = zif_abap_c=>c_sign_inc
                                                                                               option = zif_abap_c=>c_option_eq  ) ).

      sort tr_domanme_fv by low.
      delete adjacent duplicates from tr_domanme_fv comparing low.

      if tr_domanme_fv is not initial.

        select distinct domname, domvalue_l as value, ddtext as text
          from
           dd07t
          into corresponding fields of table @mt_domain_val
          where domname in @tr_domanme_fv and
                ddlanguage = @sy-langu.

      endif.

    endif.

    loop at mt_fcat reference into lo_fcat where tech = abap_false.

      lo_fcat->col_pos   = lines( fieldcat_temp ) + 1.
      append lo_fcat->* to fieldcat_temp.

      if lo_fcat->fieldname = 'WEIGHT'.
        append initial line to fieldcat_temp assigning field-symbol(<ff>).
        <ff>-col_pos   = lines( fieldcat_temp ).
        <ff>-fieldname = |{ lo_fcat->fieldname }_DEC|.
        <ff>-INTTYPE   = 'I'.
        <ff>-OUTPUTLEN = '10'.
        <ff>-reptext   = |Miejsca dziesiętne|.
        <ff>-col_opt   = abap_true.
        <ff>-no_out    = abap_true.
        assign fieldcat_temp[ fieldname = lo_fcat->fieldname ] to field-symbol(<fieldname_source>).
        <fieldname_source>-decmlfield = 'WEIGHT_DEC'.
        <fieldname_source>-tech_form  = '10'.
        <fieldname_source>-indx_decml = '50'.
        clear <fieldname_source>-decimals_o.
      endif.



      try.

          data(domain_c) = domain_config[ domname = lo_fcat->domname ].

          check lo_fcat->convexit <> 'CUNIT'.
          check lo_fcat->datatype <> 'UNIT'.

          append initial line to mt_domain_c assigning field-symbol(<domain_c>).
          <domain_c>-domname    = lo_fcat->domname.
          <domain_c>-field      = lo_fcat->fieldname.
          <domain_c>-field_d    = |{ lo_fcat->fieldname }_DV|.
          <domain_c>-fix_values = domain_c-fix_values.
          <domain_c>-table      = domain_c-entitytab.
          <domain_c>-txt_table  = domain_c-txt_table.

          assign fieldcat_temp[ fieldname = lo_fcat->fieldname ] to <fieldname_source>.
          <fieldname_source>-txt_field    = |{ lo_fcat->fieldname }_DV|.

          lo_fcat->col_pos   = lines( fieldcat_temp ).
          lo_fcat->fieldname = |{ lo_fcat->fieldname }_DV|.
          lo_fcat->intlen    = '000060'.
          lo_fcat->dd_outlen = '000060'.
          lo_fcat->reptext   = |{ lo_fcat->scrtext_l }|.
          lo_fcat->col_opt   = abap_true.
          clear lo_fcat->ref_table.
          clear lo_fcat->domname.

          append lo_fcat->* to fieldcat_temp.

        catch cx_sy_itab_line_not_found.

      endtry.

    endloop.

    loop at mt_domain_c assigning <domain_c> where fix_values = abap_true.

      data(domains_xfeld) = mt_domain_val[].
      delete domains_xfeld where domname <> <domain_c>-domname.

      if lines( domains_xfeld ) = 2 and line_exists( domains_xfeld[ value = abap_true ] )
                                    and line_exists( domains_xfeld[ value = abap_false ] ).

        read table fieldcat_temp reference into lo_fcat with key fieldname = <domain_c>-field.
        if sy-subrc = 0.
          lo_fcat->checkbox = abap_true.
        endif.

        delete mt_domain_c.

      endif.


    endloop.

    mt_fcat = fieldcat_temp.

    loop at mt_fcat reference into lo_fcat.

      if lo_fcat->domname = 'MATNR'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCMB/MDL_MATID_CE'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/TANUM'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/LGPLA'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/DO_HUIDENT'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/DO_TU_NUM'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/DO_WAVE'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.

      if lo_fcat->domname = '/SCWM/DO_WHO'.
        lo_fcat->hotspot = abap_true.
        lo_fcat->emphasize = 'C410'.
      endif.



    endloop.

  endmethod.


  method CONSTRUCTOR.

    super->constructor(
      exporting
        i_shellstyle            = iv_shellstyle
        i_lifetime              = iv_lifetime
        i_parent                = io_parent
        i_appl_events           = iv_appl_events
        i_parentdbg             = io_parentdbg
        i_applogparent          = io_applogparent
        i_graphicsparent        = io_graphicsparent
        i_name                  = iv_name
        i_fcat_complete         = iv_fcat_complete
        o_previous_sral_handler = io_previous_sral_handler
      exceptions
        error_cntl_create       = 1
        error_cntl_init         = 2
        error_cntl_link         = 3
        error_dp_create         = 4
        others                  = 5 ).
    if sy-subrc <> 0.

    endif.

    o_alv ?= me.


    mo_alv ?= me.

*    mo_alv->mr_data_changed

  endmethod.


  method CREATE_DYNAMIC_TABLE.

     cl_alv_table_create=>create_dynamic_table(
      exporting
        it_fieldcatalog           = get_fcat( )
      importing
        ep_table                  = ro_data
      exceptions
        generate_subpool_dir_full = 1
        others                    = 2 ).
    if sy-subrc <> 0.

    endif.

  endmethod.


  method CREATE_HOTSPOT_FCAT.

    cs_fcat-hotspot = abap_true.

  endmethod.


  method CREATE_ICON_FCAT.

    rs_fcat-fieldname = iv_fieldname.
    rs_fcat-domname   = c_icon_domain.
    rs_fcat-scrtext_s = conv #( iv_text ).
    rs_fcat-scrtext_m = conv #( iv_text ).
    rs_fcat-scrtext_l = conv #( iv_text ).
    rs_fcat-col_opt   = abap_true.
    rs_fcat-just      = 'C'.

  endmethod.


  method create_icon_withtext_fcat.

    rs_fcat-fieldname = iv_fieldname.
    rs_fcat-domname   = 'CHAR30'.
    rs_fcat-outputlen = '000030'.
    rs_fcat-intlen    = '000060'.
    rs_fcat-dd_outlen = '000060'.
    rs_fcat-scrtext_s = conv #( iv_text ).
    rs_fcat-scrtext_m = conv #( iv_text ).
    rs_fcat-scrtext_l = conv #( iv_text ).
    rs_fcat-col_opt   = abap_true.


  endmethod.


  method create_icon_with_text.

    call function 'ICON_CREATE'
      exporting
        name                  = iv_icon
        text                  = iv_icon_text
        info                  = iv_icon_qinfo
        add_stdinf            = ' '
      importing
        result                = rv_icon
      exceptions
        icon_not_found        = 1
        outputfield_too_short = 2
        others                = 3.

  endmethod.


  method extend_outtab.

    data:
      field_so    type rseloption,
      lo_struc    type ref to cl_abap_structdescr,
      select_part type string,
      where_part  type string,
      lo_values   type ref to data.

    field-symbols:
      <outtab_data> type any table,
      <temp_data>   type any table,
      <so_values>   type any table.


    ro_data = me->create_dynamic_table( ).

    assign co_data->*  to <temp_data>.
    assign ro_data->*  to <outtab_data>.

    <outtab_data> = corresponding #( co_data->* ).

    loop at mt_domain_c into data(domain_c) where txt_table is not initial.

      try.

          lo_struc ?= cl_abap_typedescr=>describe_by_name( conv #( domain_c-txt_table ) ).

          lo_struc->get_ddic_field_list(  receiving p_field_list   = data(ddic_fields)
                                          exceptions  not_found    = 1
                                                      no_ddic_type = 2
                                                      others       = 3 ).
          if sy-subrc <> 0.
            continue.
          endif.

          clear field_so.

          <temp_data> = corresponding #( <outtab_data> ).
          sort <temp_data> by (domain_c-field).
          delete adjacent duplicates from <temp_data> comparing (domain_c-field).

          "Build Select Options base on Output Table
          loop at <temp_data> assigning field-symbol(<so_field>).
            assign component domain_c-field of structure <so_field> to field-symbol(<so_value>).
            check <so_value> is assigned.
            check <so_value> is not initial.

            insert value #( low  = <so_value>
                            sign = zif_abap_c=>c_sign_inc
                            option = zif_abap_c=>c_option_eq ) into table field_so.

            unassign <so_value>.

          endloop.

          check field_so is not initial.

          clear select_part.
          clear where_part.

          try.

              data(lang_field) = ddic_fields[ convexit = 'ISOLA' ].

              where_part = |{ lang_field-fieldname } = @sy-langu|.
              data(value_field) = ddic_fields[ keyflag = abap_false lowercase = abap_true ].
              where_part = |{ where_part } AND { domain_c-field } IN @field_so|.

              select_part = |{ domain_c-field }, { value_field-fieldname }|.

            catch cx_sy_itab_line_not_found.
              continue.
          endtry.


          create data lo_values type table of (domain_c-txt_table).

          assign lo_values->* to <so_values>.

          try.

              select (select_part)
                from (domain_c-txt_table)
                where (where_part)
                 into corresponding fields of table @<so_values>.


            catch cx_sy_dynamic_osql_semantics into data(lo_excp_osql).
              continue.
          endtry.

          loop at <so_values> assigning field-symbol(<tab_line>).

            assign component domain_c-field       of structure <tab_line> to field-symbol(<domain_value>).
            assign component value_field-fieldname of structure <tab_line> to field-symbol(<ddic_value>).

            if <domain_value> is assigned and <ddic_value> is assigned.

              insert value #( domname = domain_c-domname
                              field   = domain_c-field_d
                              name    = domain_c-field_d
                              value   = <domain_value>
                              text    = <ddic_value> ) into table mt_domain_val.
            endif.

            unassign <ddic_value>.
            unassign <domain_value>.

          endloop.

        catch cx_root.
          continue.
      endtry.
    endloop.

    data(domains_fill) = mt_domain_val.

    sort domains_fill by domname.
    delete adjacent duplicates from domains_fill comparing domname.


    loop at mt_domain_c into data(domain_config).

      if line_exists( domains_fill[ domname = domain_config-domname ] ).

        try.

            loop at <outtab_data> assigning field-symbol(<outline>).
              assign component domain_config-field   of structure <outline>  to field-symbol(<source_value>).
              assign component domain_config-field_d of structure <outline>  to field-symbol(<target_value>).

              check <source_value> is assigned.
              check <target_value> is assigned.
              <target_value> = value #( mt_domain_val[ domname = domain_config-domname value = <source_value> ]-text optional ).

              unassign <source_value>.
              unassign <target_value>.

            endloop.


          catch cx_sy_itab_line_not_found.

        endtry.

      endif.

    endloop.

    loop at <outtab_data> assigning <outline>.
      assign component c_icon_domain of structure <outline>  to field-symbol(<icon>).
      check sy-subrc = 0.

*      data: icon type char30.
*
*      call function 'ICON_CREATE'
*        exporting
*          name                  = icon_display
*          text                  = 'Display'
*          info                  = 'Display Mode'
*          add_stdinf            = ' '
*        importing
*          result                = icon
*        exceptions
*          icon_not_found        = 1
*          outputfield_too_short = 2
*          OTHERS                = 3.
*      if sy-subrc <> 0.
*
*      endif.
*
*
*
*         <icon> = icon.
*         continue.



      <icon> = icon_display.

      assign component 'WEIGHT_DEC' of structure <outline>  to field-symbol(<dec>).
      if <dec> is ASSIGNED.
        <dec> = '3'.
      endif.

      UNASSIGN <dec>.

    endloop.


  endmethod.


  method zif_abap_alv~display.

    data:
      io_data       type ref to data,
      io_data_dynam type ref to data,
      io_data_tmp   type ref to data.
    field-symbols:
      <outtab>     type any table,
      <outtab_dyn> type any table,
      <outtab_tmp> type any table.

    io_data = get_outtab( ).

    data(field_catalog)   = get_fcat( ).
    data(sort_settings)   = get_sort( ).
    data(filter_settings) = get_filter( ).

    io_data_dynam = extend_outtab( changing co_data = io_data ).

    data(lo_event_handler) = new zcl_abap_alv_event_handler( ).

    set handler lo_event_handler->on_drop_external_files      for me.
    set handler lo_event_handler->on_toolbar                  for me.
    set handler lo_event_handler->on_menu_button              for me.
    set handler lo_event_handler->on_delayed_changed_sel_cbck for me.
    set handler lo_event_handler->on_delayed_callback         for me.
    set handler lo_event_handler->on_context_menu_request     for me.

    me->register_delayed_event(
      exporting
        i_event_id = cl_gui_alv_grid=>mc_evt_delayed_change_select
      exceptions
        error      = 1
        others     = 2 ).
    if sy-subrc <> 0.
    endif.

    me->register_delayed_event(
      exporting
        i_event_id = cl_gui_alv_grid=>mc_evt_delayed_move_curr_cell
      exceptions
        error      = 1
        others     = 2 ).
    if sy-subrc <> 0.
    endif.

    me->drag_accept_files( 1 ).

    me->set_table_for_first_display(
      exporting
        i_structure_name              = get_structure( )
        is_variant                    = get_variant_alv( )
        i_save                        = get_variant_save( )
        i_default                     = abap_true
        is_layout                     = get_layout( )
        is_print                      = get_print( )
        it_special_groups             = get_sgroups( )
        it_toolbar_excluding          = get_toolbar_exc( )
        it_hyperlink                  = get_hyperlinks( )
        it_except_qinfo               = get_qinfo( )
      changing
        it_outtab                     = io_data_dynam->*
        it_fieldcatalog               = field_catalog
        it_sort                       = sort_settings
        it_filter                     = filter_settings
      exceptions
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        others                        = 4 ).
    if sy-subrc <> 0.

    endif.



    ro_self ?= me.

  endmethod.


  method ZIF_ABAP_ALV~GET_CHECKBOX_FIELDS.
  endmethod.


  method zif_abap_alv~get_fcat.

    if mt_fcat is initial.
       build_fcat( ).
    endif.

    rt_fcat = mt_fcat[].

  endmethod.


  method ZIF_ABAP_ALV~GET_FILTER.
  endmethod.


  method ZIF_ABAP_ALV~GET_HOTSPOTS_FIELDS.

    rt_hotspot = value #( for hotspot in mt_fcat where ( hotspot = abap_true ) ( hotspot ) ).

  endmethod.


  method ZIF_ABAP_ALV~GET_HYPERLINKS.
  endmethod.


  method ZIF_ABAP_ALV~GET_ICON_FIELDS.
  endmethod.


  method ZIF_ABAP_ALV~GET_LAYOUT.
    rs_layout-cwidth_opt = abap_true.
    rs_layout-zebra      = abap_true.
    rs_layout-grid_title = 'Testowa ALV'.
    rs_layout-sel_mode   = 'A'.
  endmethod.


  method ZIF_ABAP_ALV~GET_OUTTAB.

    ro_tab = mo_model->get_model( ).

  endmethod.


  method ZIF_ABAP_ALV~GET_PRINT.
  endmethod.


  method ZIF_ABAP_ALV~GET_QINFO.
  endmethod.


  method ZIF_ABAP_ALV~GET_SETTINGS.
    ro_settings = mo_alv_settings.
  endmethod.


  method ZIF_ABAP_ALV~GET_SGROUPS.
  endmethod.


  method ZIF_ABAP_ALV~GET_SORT.
  endmethod.


  method ZIF_ABAP_ALV~GET_STRUCTURE.
  endmethod.


  method ZIF_ABAP_ALV~GET_TOOLBAR_EXC.
  endmethod.


  method ZIF_ABAP_ALV~GET_VARIANT.
    rs_variant-report = sy-repid.
  endmethod.


  method ZIF_ABAP_ALV~GET_VARIANT_SAVE.
    rv_save_mode = zif_abap_alv=>c_variant_save_all.
  endmethod.


  method ZIF_ABAP_ALV~SET_MODEL.
    mo_model ?= io_model.
  endmethod.


  method ZIF_ABAP_ALV~SET_SETTINGS.
    mo_alv_settings = io_settings.
  endmethod.


  method ZIF_ABAP_ALV~GET_QUAN_FIELDS.

    rt_fcat = value #( for hotspot in mt_fcat where (  datatype = 'QUAN' ) ( hotspot ) ).

  endmethod.
ENDCLASS.
