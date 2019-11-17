*"* use this source file for your ABAP unit test classes

CLASS ltc_main DEFINITION
      FOR TESTING
      DURATION SHORT
      RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
    DATA dref TYPE REF TO data.

ENDCLASS.

CLASS ltc_main IMPLEMENTATION.

  METHOD test.
    TYPES:
      basetype TYPE c LENGTH 2,
      BEGIN OF ENUM enum_size BASE TYPE basetype,
        size_i  VALUE IS INITIAL,
        size_l  VALUE `L`,
        size_xl VALUE `XL`,
      END OF ENUM enum_size.
    DATA(size) = size_xl.
    DATA(rtti) = cl_abap_typedescr=>describe_by_data( size ).
    DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( size ).
  ENDMETHOD.

ENDCLASS.
