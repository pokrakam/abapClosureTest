REPORT zobject_instance_lifetime.

CLASS lcl_test DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    DATA some_i TYPE i.
    DATA short_string TYPE string.
    DATA long_string TYPE string.

    DATA small_itab TYPE STANDARD TABLE OF i.
    DATA large_itab TYPE STANDARD TABLE OF i.

    METHODS get_string_ref RETURNING VALUE(result) TYPE REF TO string.
    METHODS fill_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_test IMPLEMENTATION.

  METHOD get_string_ref.
    result = REF #( long_string ).
  ENDMETHOD.

  METHOD fill_data.

    short_string = 'Foo'.

    long_string = `1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890` &&
                  `1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890` &&
                  `1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890` &&
                  `1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890` &&
                  `1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890`.

    DO 5 TIMES.
      APPEND sy-index TO small_itab.
    ENDDO.

    DO 10000 TIMES.
      APPEND sy-index TO large_itab.
    ENDDO.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_main DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS run.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD run.

    DATA(o) = NEW lcl_test( ).
    o->short_string = `Foo`.
    CLEAR o.
    cl_abap_memory_utilities=>do_garbage_collection( ).

    o = NEW lcl_test( ).
    o->short_string = `Foo`.
    CLEAR o.
    cl_abap_memory_utilities=>do_garbage_collection( ).

    o = NEW lcl_test( ).
    o->fill_data( ).
    DATA(sref) = o->get_string_ref( ).
    CLEAR o.
    cl_abap_memory_utilities=>do_garbage_collection( ).

    CLEAR sref.

    cl_abap_memory_utilities=>do_garbage_collection( ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  NEW lcl_main( )->run( ).
