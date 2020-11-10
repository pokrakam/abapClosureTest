REPORT zdata_object_lifetime_test.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS get_num_ref RETURNING VALUE(result) TYPE REF TO i.
  PRIVATE SECTION.
    DATA i TYPE i.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD get_num_ref.
    i = 4.
    GET REFERENCE OF i INTO result.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(o) = NEW lcl_main( ).
  DATA(iref) = o->get_num_ref( ).
  CLEAR o.
  cl_abap_memory_utilities=>do_garbage_collection( ).
  WRITE / iref->*.
