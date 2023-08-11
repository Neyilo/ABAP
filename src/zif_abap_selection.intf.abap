interface ZIF_ABAP_SELECTION
  public .


  types:
    begin of ty_selection,
         name  type string,
         type  type zabap_selection_type,
         so    type rseloption,
         value type string,
         end of ty_selection .
  types:
    tty_selection type hashed table of ty_selection with unique key name type .

  constants C_SELECTION_SO type ZABAP_SELECTION_TYPE value 'S' ##NO_TEXT.
  constants C_SELECTION_P type ZABAP_SELECTION_TYPE value 'P' ##NO_TEXT.

  methods GET_SELECTION_DATA
    returning
      value(RT_SELECTION) type TTY_SELECTION .
endinterface.
