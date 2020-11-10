REPORT zclosure.

*--------------------------------------------------------------------*
INTERFACE lif_number.
*--------------------------------------------------------------------*
  METHODS add IMPORTING i             TYPE i
              RETURNING VALUE(result) TYPE i.
ENDINTERFACE.

*--------------------------------------------------------------------*
CLASS lcl_number DEFINITION.
*--------------------------------------------------------------------*

  PUBLIC SECTION.
    INTERFACES lif_number.
    CLASS-METHODS create IMPORTING i             TYPE REF TO i
                         RETURNING VALUE(result) TYPE REF TO lif_number.

  PRIVATE SECTION.
    DATA iref TYPE REF TO i.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS lcl_number IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD create.
    DATA(num) = NEW lcl_number( ).
    num->iref = i.
    result = num.
  ENDMETHOD.

  METHOD lif_number~add.
    ASSIGN iref->* TO FIELD-SYMBOL(<i>).
    <i> = <i> + i.
    result = <i>.
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS lcl_main DEFINITION.
*--------------------------------------------------------------------*

  PUBLIC SECTION.
    METHODS get_num RETURNING VALUE(result) TYPE REF TO lif_number.

  PRIVATE SECTION.
    DATA i TYPE i.

ENDCLASS.

*--------------------------------------------------------------------*
CLASS lcl_main IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD get_num.
    result = lcl_number=>create( REF #( i ) ).
  ENDMETHOD.

ENDCLASS.

*--------------------------------------------------------------------*
START-OF-SELECTION.
*--------------------------------------------------------------------*

  DATA o TYPE REF TO lcl_main.

  o = NEW lcl_main( ).
  DATA(num1) = o->get_num( ).

  o = NEW lcl_main( ).
  DATA(num2) = o->get_num( ).

  CLEAR o.

  WRITE / |Num1 add 1 three times: { num1->add( 1 ) }, { num1->add( 1 ) }, { num1->add( 1 ) }|.
  WRITE / |Num2 add 1 two times  : { num2->add( 1 ) }, { num2->add( 1 ) }|.

  write / 'Collect garbage'.
  cl_abap_memory_utilities=>do_garbage_collection( ).

  WRITE / |Num1 add 2 three times: { num1->add( 2 ) }, { num1->add( 2 ) }, { num1->add( 2 ) }|.
  WRITE / |Num2 add 2 two times  : { num2->add( 2 ) }, { num2->add( 2 ) }|.
