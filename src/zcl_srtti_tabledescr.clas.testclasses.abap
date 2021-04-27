*"* use this source file for your ABAP unit test classes
CLASS ltc_main DEFINITION
      FOR TESTING
      DURATION SHORT
      RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_line_with_components,
             very__very_long_component_name TYPE i,
           END OF ty_line_with_components,
           ty_std_table_comps_empty_key TYPE STANDARD TABLE OF ty_line_with_components WITH EMPTY KEY.

    METHODS check_instantiated_classes FOR TESTING.
    METHODS bound_line_type FOR TESTING.

    METHODS assert_copy_equals_original
      IMPORTING
        srtti    TYPE REF TO zcl_srtti_typedescr
        original TYPE ltc_main=>ty_std_table_comps_empty_key.
ENDCLASS.

CLASS ltc_main IMPLEMENTATION.

  METHOD check_instantiated_classes.

    DATA: dref TYPE REF TO data.

    DATA(rtti) = cl_abap_tabledescr=>create(
             p_line_type = cl_abap_structdescr=>create( p_components = VALUE abap_component_tab(
                           ( name = 'VERY__VERY_LONG_COMPONENT_NAME' type = cl_abap_elemdescr=>get_i( ) ) ) ) ).
    CREATE DATA dref TYPE HANDLE rtti.
    ASSIGN dref->* TO FIELD-SYMBOL(<original>).

    DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( <original> ).
    cl_abap_unit_assert=>assert_true( act = boolc( srtti IS INSTANCE OF zcl_srtti_tabledescr ) ).
    DATA(srtti2) = CAST zcl_srtti_tabledescr( srtti )->line_type.
    cl_abap_unit_assert=>assert_true( act = boolc( srtti2 IS INSTANCE OF zcl_srtti_structdescr ) ).

  ENDMETHOD.

  METHOD bound_line_type.

    DATA: dref TYPE REF TO data.

    DATA(fill_original_data) = VALUE ty_std_table_comps_empty_key(
        ( very__very_long_component_name = 25 )
        ( very__very_long_component_name = 37 ) ).

    DATA(rtti) = cl_abap_tabledescr=>create(
             p_line_type = cl_abap_structdescr=>create( p_components = VALUE abap_component_tab(
                           ( name = 'VERY__VERY_LONG_COMPONENT_NAME' type = cl_abap_elemdescr=>get_i( ) ) ) ) ).
    CREATE DATA dref TYPE HANDLE rtti.
    ASSIGN dref->* TO FIELD-SYMBOL(<original>).
    <original> = CORRESPONDING #( fill_original_data ).

    DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( <original> ).

    assert_copy_equals_original( srtti = srtti original = <original> ).

  ENDMETHOD.

  METHOD assert_copy_equals_original.

    DATA dref TYPE REF TO data.

    DATA(rtti) = CAST cl_abap_tabledescr( srtti->get_rtti( ) ).
    CREATE DATA dref TYPE HANDLE rtti.
    ASSIGN dref->* TO FIELD-SYMBOL(<copy>).
    <copy> = original.
    cl_abap_unit_assert=>assert_equals( act = <copy> exp = original ).

  ENDMETHOD.

ENDCLASS.
