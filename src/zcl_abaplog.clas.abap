class ZCL_ABAPLOG definition
  public
  create private .

public section.

  interfaces ZIF_ABAPLOG .

  aliases C_ABORT
    for ZIF_ABAPLOG~C_ABORT .
  aliases C_ERROR
    for ZIF_ABAPLOG~C_ERROR .
  aliases C_INFORMATION
    for ZIF_ABAPLOG~C_INFORMATION .
  aliases C_SUCCESS
    for ZIF_ABAPLOG~C_SUCCESS .
  aliases C_WARNING
    for ZIF_ABAPLOG~C_WARNING .
  aliases DB_NUMBER
    for ZIF_ABAPLOG~DB_NUMBER .
  aliases ABORT
    for ZIF_ABAPLOG~ABORT .
  aliases ADD
    for ZIF_ABAPLOG~ADD .
  aliases DISPLAY_FULLSCREEN
    for ZIF_ABAPLOG~DISPLAY_FULLSCREEN .
  aliases DISPLAY_POPUP
    for ZIF_ABAPLOG~DISPLAY_POPUP .
  aliases ERROR
    for ZIF_ABAPLOG~ERROR .
  aliases EXPORT_TO_TABLE
    for ZIF_ABAPLOG~EXPORT_TO_TABLE .
  aliases GET_SEVERITY
    for ZIF_ABAPLOG~GET_SEVERITY .
  aliases HAS_ERRORS
    for ZIF_ABAPLOG~HAS_ERRORS .
  aliases HAS_WARNINGS
    for ZIF_ABAPLOG~HAS_WARNINGS .
  aliases INFORMATION
    for ZIF_ABAPLOG~INFORMATION .
  aliases IS_EMPTY
    for ZIF_ABAPLOG~IS_EMPTY .
  aliases LENGTH
    for ZIF_ABAPLOG~LENGTH .
  aliases REFRESH
    for ZIF_ABAPLOG~REFRESH .
  aliases SAVE
    for ZIF_ABAPLOG~SAVE .
  aliases SET_DEFAULT_SETTINGS
    for ZIF_ABAPLOG~SET_DEFAULT_SETTINGS .
  aliases SUCCESS
    for ZIF_ABAPLOG~SUCCESS .
  aliases WARNING
    for ZIF_ABAPLOG~WARNING .

  types:
    tty_exception_data type standard table of bal_s_exc with default key .
  types:
    tty_bal_msg type table of bal_s_msg .
  types:
    begin of ty_exception,
      level     type i,
      exception type ref to cx_root,
      end of ty_exception .

  class-methods GET_INSTANCE
    importing
      !IV_NEW type ABAP_BOOL optional
    returning
      value(RO_LOG) type ref to ZCL_ABAPLOG .
  methods CREATE_LOG
    importing
      !IS_LOG type BAL_S_LOG optional
      !IV_EXTNUMBER type BALNREXT optional
      !IV_OBJECT type BALOBJ_D optional
      !IV_SUBOBJECT type BALSUBOBJ optional
      !IS_CONTEXT type BAL_S_CONT optional
      !IS_PARAMS type BAL_S_PARM optional .
  methods GET_LOGHNDL
    returning
      value(RV_LOGHNDL) type BALLOGHNDL .
  methods CHANGE_EXTNUMBER
    importing
      !IV_EXT_ID type BAL_S_LOG-EXTNUMBER .
protected section.
private section.

  aliases HANDLE
    for ZIF_ABAPLOG~HANDLE .
  aliases HEADER
    for ZIF_ABAPLOG~HEADER .

  class-data SO_LOG type ref to ZCL_ABAPLOG .

  methods GET_EXCEPTION_LIST
    importing
      !IV_LOG type ANY
      !IV_TYPE type MSGTY
      !IV_IMPORTANCE type BALPROBCL
    returning
      value(RT_EXCEPTIONS) type TTY_EXCEPTION_DATA .
  methods FILL_MESSAGE
    importing
      !IV_LOG type ANY
    changing
      !CS_MESSAGE type BAL_S_MSG .
  methods GET_MESSAGE_HANDLES
    importing
      !IV_MSGTY type MSGTY optional
    returning
      value(RT_MESSAGE_HANDLES) type BAL_T_MSGH .
ENDCLASS.



CLASS ZCL_ABAPLOG IMPLEMENTATION.


  method create_log.

    data: bal_log type bal_s_log.

    if is_log is supplied.
      bal_log = is_log.
    else.
      bal_log-extnumber = iv_extnumber.
      bal_log-object    = iv_object.
      bal_log-subobject = iv_subobject.
      bal_log-params    = is_params.
      bal_log-context   = is_context.
    endif.

    bal_log-aldate    = sy-datum.
    bal_log-altime    = sy-uzeit.
    bal_log-aluser    = sy-uname.
    bal_log-altcode   = sy-tcode.
    bal_log-alprog    = sy-cprog.

    set_default_settings( changing cs_ballog = bal_log ).

    call function 'BAL_LOG_CREATE'
      exporting
        i_s_log                 = bal_log
      importing
        e_log_handle            = handle
      exceptions
        log_header_inconsistent = 1
        others                  = 2.

    call function 'BAL_LOG_HDR_READ'
      exporting
        i_log_handle  = handle
      importing
        e_s_log       = header
        e_lognumber   = db_number
      exceptions
        log_not_found = 1
        others        = 2.

  endmethod.


  method get_instance.

    if so_log is not bound or iv_new = abap_true.
      so_log  = new zcl_abaplog( ).
    endif.

    ro_log = so_log.
  endmethod.


  method get_loghndl.
    rv_loghndl = handle.
  endmethod.


  method FILL_MESSAGE.

    cs_message = corresponding #( base ( cs_message ) iv_log ).

    check cs_message-msgty is initial.

    assign component 'TYPE'       of structure iv_log to field-symbol(<type>).
    assign component 'ID'         of structure iv_log to field-symbol(<id>).
    assign component 'NUMBER'     of structure iv_log to field-symbol(<number>).
    assign component 'MESSAGE_V1' of structure iv_log to field-symbol(<message_v1>).
    assign component 'MESSAGE_V2' of structure iv_log to field-symbol(<message_v2>).
    assign component 'MESSAGE_V3' of structure iv_log to field-symbol(<message_v3>).
    assign component 'MESSAGE_V4' of structure iv_log to field-symbol(<message_v4>).

    cs_message-msgid = <id>.
    cs_message-msgty = <type>.
    cs_message-msgno = <number>.
    cs_message-msgv1 = <message_v1>.
    cs_message-msgv2 = <message_v2>.
    cs_message-msgv3 = <message_v3>.
    cs_message-msgv4 = <message_v4>.

  endmethod.


  method get_message_handles.

    if iv_msgty is supplied.
      data(filter) = value bal_s_mfil( msgty = value #( ( low = iv_msgty option = zif_abap_c=>c_option_eq sign = zif_abap_c=>c_sign_inc ) ) ).
    endif.

    call function 'BAL_GLB_SEARCH_MSG'
      exporting
        i_t_log_handle = value bal_t_logh( ( handle ) )
        i_s_msg_filter = filter
      importing
        e_t_msg_handle = rt_message_handles
      exceptions
        msg_not_found  = 0.

  endmethod.


  method zif_abaplog~abort.

    ro_Log = me->add( iv_log         = iv_log
                      iv_type        = iv_type
                      iv_context     = iv_context
                      iv_callback_fm = iv_callback_fm
                      iv_importance  = iv_importance ).

  endmethod.


  method zif_abaplog~add.

    field-symbols:
      <any_table> type any table.

    data:
      detailed_msg type bal_s_msg,
      lo_mtype     type ref to cl_abap_typedescr.

    get time stamp field detailed_msg-time_stmp.
    detailed_msg-probclass = iv_importance.

    if iv_callback_fm is not initial.
      detailed_msg-params-callback-userexitt = 'F'.
      detailed_msg-params-callback-userexitf = iv_callback_fm.
    endif.

    if iv_context is not initial.
      assign iv_context to field-symbol(<context>).
      detailed_msg-context-value   = <context>.

      cl_abap_typedescr=>describe_by_data( iv_context )->get_ddic_header(
        receiving
          p_header     = data(context_ddic)
        exceptions
          not_found    = 1
          no_ddic_type = 2
          others       = 3 ).
      if sy-subrc = 0.
        detailed_msg-context-tabname = context_ddic-tabname.
      endif.
    endif.

    lo_mtype ?= cl_abap_typedescr=>describe_by_data( p_data = iv_log ).

    if iv_log is initial.
      detailed_msg-msgty = sy-msgty.
      detailed_msg-msgid = sy-msgid.
      detailed_msg-msgno = sy-msgno.
      detailed_msg-msgv1 = sy-msgv1.
      detailed_msg-msgv2 = sy-msgv2.
      detailed_msg-msgv3 = sy-msgv3.
      detailed_msg-msgv4 = sy-msgv4.

      if iv_type is not initial.
        detailed_msg-msgty = iv_type.
      endif.
    else.

      case lo_mtype->kind.

        when cl_abap_typedescr=>kind_struct.
          fill_message( exporting iv_log     = iv_log
                        changing  cs_message = detailed_msg ).

          call function 'BAL_LOG_MSG_ADD'
            exporting
              i_log_handle     = me->handle
              i_s_msg          = detailed_msg
            exceptions
              log_is_full      = 1
              log_not_found    = 2
              msg_inconsistent = 3.

        when cl_abap_typedescr=>kind_table.
          assign iv_log to <any_table>.
          loop at <any_table> assigning field-symbol(<message>).
            add( <message> ).
          endloop.

        when cl_abap_typedescr=>kind_ref.

          if lo_mtype->type_kind = cl_abap_typedescr=>typekind_oref.
            loop at get_exception_list( iv_log        = iv_log
                                        iv_type       = iv_type
                                        iv_importance = iv_importance ) reference into data(lo_exception).
              call function 'BAL_LOG_EXCEPTION_ADD'
                exporting
                  i_log_handle = me->handle
                  i_s_exc      = lo_exception->*.
            endloop.

          endif.

        when cl_abap_typedescr=>kind_elem.

          call function 'BAL_LOG_MSG_ADD_FREE_TEXT'
            exporting
              i_log_handle = me->handle
              i_msgty      = iv_type
              i_probclass  = iv_importance
              i_text       = conv char200( iv_log )
              i_s_context  = detailed_msg-context
              i_s_params   = detailed_msg-params.

      endcase.

    endif.

    ro_log = me.

  endmethod.


  method zif_abaplog~display_fullscreen.

    data:
      profile        type bal_s_prof,
      lt_log_handles type bal_t_logh.

    append me->handle to lt_log_handles.

    call function 'BAL_DSP_PROFILE_SINGLE_LOG_GET'
      importing
        e_s_display_profile = profile.

    try.
        profile-mess_fcat[ ref_field = 'MSG_STMP' ]-no_out = abap_false.
      catch cx_sy_itab_line_not_found.
    endtry.

    call function 'BAL_DSP_LOG_DISPLAY'
      exporting
        i_s_display_profile = profile
        i_t_log_handle      = lt_log_handles.

  endmethod.


  method zif_abaplog~display_popup.

    data:
      profile        type bal_s_prof,
      lt_log_handles type bal_t_logh,
      bal_show       type bal_s_show.

    append me->handle to lt_log_handles.

    call function 'BAL_DSP_PROFILE_POPUP_GET'
      importing
        e_s_display_profile = profile.

    profile-use_grid   = abap_true.
    profile-cwidth_opt = abap_true.

    call function 'BAL_DSP_LOG_DISPLAY'
      exporting
        i_s_display_profile = profile
        i_t_log_handle      = lt_log_handles.

  endmethod.


  method zif_abaplog~error.
    ro_Log = me->add( iv_log         = iv_log
                      iv_type        = iv_type
                      iv_context     = iv_context
                      iv_callback_fm = iv_callback_fm
                      iv_importance  = iv_importance ).
  endmethod.


  method zif_abaplog~export_to_table.

    data: bal_msg type bal_s_msg.

    loop at me->get_message_handles( ) reference into data(lo_mhandle).

      call function 'BAL_LOG_MSG_READ'
        exporting
          i_s_msg_handle = lo_mhandle->*
        importing
          e_s_msg        = bal_msg
        exceptions
          log_not_found  = 1
          msg_not_found  = 2
          others         = 3.

      if sy-subrc <> 0.
        continue.
      endif.

      append initial line to et_bapiret assigning field-symbol(<message>).
      <message>-id         = bal_msg-msgid.
      <message>-type       = bal_msg-msgty.
      <message>-number     = bal_msg-msgno.
      <message>-message_v1 = bal_msg-msgv1.
      <message>-message_v2 = bal_msg-msgv2.
      <message>-message_v3 = bal_msg-msgv3.
      <message>-message_v4 = bal_msg-msgv4.
      <message>-system     = sy-sysid.
      <message>-log_no     = lo_mhandle->log_handle.
      <message>-log_msg_no = lo_mhandle->msgnumber.
      <message>-type       = bal_msg-msgty.

    endloop.

  endmethod.


  method zif_abaplog~get_severity.

    data: bal_msg type bal_s_msg.

    loop at me->get_message_handles( ) reference into data(lo_mhandle).

      call function 'BAL_LOG_MSG_READ'
        exporting
          i_s_msg_handle           = lo_mhandle->*
        importing
          e_s_msg                  = bal_msg
        exceptions
          log_not_found            = 1
          msg_not_found            = 2
          others                   = 3.

      if sy-subrc <> 0.
         continue.
      endif.

      check bal_msg-msgty ne rv_severity.

      case bal_msg-msgty.

        when c_information.
          check rv_severity is initial.
        when c_warning.
          check rv_severity is initial or rv_severity = c_information.
        when c_success.
          check rv_severity is initial or rv_severity = c_information
                                       or rv_severity = c_success.
        when c_error.

        when c_abort.
          bal_msg-msgty = 'E'.
      endcase.

      rv_severity = bal_msg-msgty.

      if rv_severity = c_error.
         exit.
      endif.

    endloop.

  endmethod.


  method zif_abaplog~has_errors.
    rv_yes = boolc( lines( get_message_handles( c_error ) ) ne 0 ).
  endmethod.


  method zif_abaplog~has_warnings.

    rv_yes = boolc( lines( get_message_handles( c_warning ) ) ne 0 ).

  endmethod.


  method zif_abaplog~information.
    ro_Log = me->add( iv_log         = iv_log
                      iv_type        = iv_type
                      iv_context     = iv_context
                      iv_callback_fm = iv_callback_fm
                      iv_importance  = iv_importance ).
  endmethod.


  method zif_abaplog~is_empty.

    rv_yes = boolc( length( ) = 0 ).

  endmethod.


  method zif_abaplog~length.

    rv_length = lines( me->get_message_handles( iv_msgty = c_information ) ).

  endmethod.


  method zif_abaplog~refresh.

    call function 'BAL_LOG_MSG_DELETE_ALL'
      exporting
        i_log_handle  = handle
      exceptions
        log_not_found = 1
        others        = 2.

  endmethod.


  method zif_abaplog~save.

    data: log_handles type bal_t_logh,
          log_numbers type bal_t_lgnm.

    append me->handle to log_handles.

    call function 'BAL_DB_SAVE'
      exporting
        i_t_log_handle       = log_handles
      importing
        e_new_lognumbers     = log_numbers.

    if me->db_number is initial.
      read table log_numbers index 1 into data(log_number).
      me->db_number = log_number-lognumber.
    endif.

  endmethod.


  method ZIF_ABAPLOG~SUCCESS.
     ro_Log = me->add( iv_log         = iv_log
                       iv_type        = iv_type
                       iv_context     = iv_context
                       iv_callback_fm = iv_callback_fm
                       iv_importance  = iv_importance ).
  endmethod.


  method zif_abaplog~warning.
    ro_Log = me->add( iv_log         = iv_log
                      iv_type        = iv_type
                      iv_context     = iv_context
                      iv_callback_fm = iv_callback_fm
                      iv_importance  = iv_importance ).
  endmethod.


  method CHANGE_EXTNUMBER.

    call function 'BAL_LOG_HDR_READ'
      exporting
        i_log_handle  = handle
      importing
        e_s_log       = header
      exceptions
        log_not_found = 1
        others        = 2.
    if sy-subrc <> 0.

    endif.

    header-extnumber = iv_ext_id.

    call function 'BAL_LOG_HDR_CHANGE'
      exporting
        i_log_handle            = handle
        i_s_log                 = header
      exceptions
        log_not_found           = 1
        log_header_inconsistent = 2
        others                  = 3.
    if sy-subrc ne 0.

    endif.

  endmethod.


  method GET_EXCEPTION_LIST.

     data:
       previous_exception type ref to cx_root,
       exceptions_list    type table of ty_exception with empty key.

    append initial line to exceptions_list assigning field-symbol(<exception>).
    <exception>-level      = 1.
    <exception>-exception ?= iv_log.

    previous_exception    ?= iv_log.

    while previous_exception is bound.
      if previous_exception->previous is not bound.
        exit.
      endif.

      previous_exception ?= previous_exception->previous.

      append initial line to exceptions_list assigning <exception>.
      <exception>-level = lines( exceptions_list ).
      <exception>-exception = previous_exception.

    endwhile.

    sort exceptions_list by level descending.

    loop at exceptions_list assigning <exception>.
      append initial line to rt_exceptions assigning field-symbol(<exception_data>).
      <exception_data>-exception = <exception>-exception.
      <exception_data>-msgty     = iv_type.
      <exception_data>-probclass = iv_importance.
    endloop.

  endmethod.


  method ZIF_ABAPLOG~SET_DEFAULT_SETTINGS.
    cs_ballog-del_before = abap_true.
    cs_ballog-aldate_del = sy-datum + 15.
  endmethod.
ENDCLASS.
