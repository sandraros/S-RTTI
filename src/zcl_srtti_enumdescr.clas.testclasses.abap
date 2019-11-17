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
    " NB: possible short dump SYSTEM_CORE_DUMPED at activation (hold of 2 or 3 minutes)
    "     because of enumeration in test class (occurred with kernel 753 SP16).
    "     Solution: maybe note 2526439 (install kernel 753 SP19) -> solved with kernel 753 SP500
    TYPES:
      basetype TYPE c LENGTH 2,
      BEGIN OF ENUM enum_size BASE TYPE basetype,
        size_i  VALUE IS INITIAL,
        size_l  VALUE `L`,
        size_xl VALUE `XL`,
      END OF ENUM enum_size.

    DATA(size) = size_xl.

data(a) = 1.
data(B) = 1.
data(c) = 1.
data(D) = 1.

zcl_srtti_aunit=>serialize_deserialize( size ).


*    DATA(rtti) = cl_abap_typedescr=>describe_by_data( size ).
*    DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( size ).
  ENDMETHOD.

ENDCLASS.
