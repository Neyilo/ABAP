class ZCL_EX_ALV_EVENTS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZIF_ABAP_ALV_EVENT_HANDLER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EX_ALV_EVENTS IMPLEMENTATION.


  method ZIF_ABAP_ALV_EVENT_HANDLER~HOTSPOT_CLICK.

    break gdziezyk.
    cv_prevent_default = abap_false.

  endmethod.
ENDCLASS.
