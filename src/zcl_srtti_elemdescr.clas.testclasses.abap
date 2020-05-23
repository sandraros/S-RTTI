*"* use this source file for your ABAP unit test classes

CLASS ltc_subclass DEFINITION INHERITING FROM zcl_srtti_elemdescr.
  PUBLIC SECTION.
    METHODS get_rtti_by_type_kind_2
      IMPORTING
        i_type_kind LIKE cl_abap_typedescr=>type_kind
      RETURNING
        VALUE(rtti) TYPE REF TO cl_abap_typedescr.
ENDCLASS.

CLASS ltc_subclass IMPLEMENTATION.
  METHOD get_rtti_by_type_kind_2.
    rtti = get_rtti_by_type_kind( i_type_kind ).
  ENDMETHOD.
ENDCLASS.

CLASS ltc_main DEFINITION
      FOR TESTING
      DURATION SHORT
      RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS serialize_deserialize FOR TESTING.
    METHODS get_rtti_by_type_kind FOR TESTING.
    METHODS get_rtti_by_type_kind_enum FOR TESTING.
    METHODS get_rtti_by_type_kind_assert
      IMPORTING
        variable TYPE simple.
    DATA dref TYPE REF TO data.

ENDCLASS.

CLASS ltc_main IMPLEMENTATION.

  METHOD serialize_deserialize.
    DATA variable TYPE c LENGTH 20.
    variable = 'Hello World'.
    zcl_srtti_aunit=>serialize_deserialize( variable ).
  ENDMETHOD.

  METHOD get_rtti_by_type_kind_assert.
    DATA(rtti) = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_data( variable ) ).
    DATA(rtti2) = NEW ltc_subclass( rtti )->get_rtti_by_type_kind_2( rtti->type_kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'decimals'  exp = rtti->decimals  act = rtti2->decimals ).
    cl_abap_unit_assert=>assert_equals( msg = 'type_kind' exp = rtti->type_kind act = rtti2->type_kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'length'    exp = rtti->length    act = rtti2->length ).
  ENDMETHOD.

  METHOD get_rtti_by_type_kind.
    DATA n          TYPE n LENGTH 20.
    DATA c          TYPE c LENGTH 20.
    DATA string     TYPE string.
    DATA xstring    TYPE xstring.
    DATA i          TYPE i.
    DATA f          TYPE f.
    DATA d          TYPE d.
    DATA t          TYPE t.
    DATA x          TYPE x LENGTH 20.
    DATA p          TYPE p LENGTH 10 DECIMALS 3.
    DATA int1       TYPE int1.
    DATA int2       TYPE int2.
    DATA int8       TYPE int8.
    DATA decfloat16 TYPE decfloat16.
    DATA decfloat34 TYPE decfloat34.

    get_rtti_by_type_kind_assert( n          ).
    get_rtti_by_type_kind_assert( c          ).
    get_rtti_by_type_kind_assert( string     ).
    get_rtti_by_type_kind_assert( xstring    ).
    get_rtti_by_type_kind_assert( i          ).
    get_rtti_by_type_kind_assert( f          ).
    get_rtti_by_type_kind_assert( d          ).
    get_rtti_by_type_kind_assert( t          ).
    get_rtti_by_type_kind_assert( x          ).
    get_rtti_by_type_kind_assert( p          ).
    get_rtti_by_type_kind_assert( int1       ).
    get_rtti_by_type_kind_assert( int2       ).
    get_rtti_by_type_kind_assert( int8       ).
    get_rtti_by_type_kind_assert( decfloat16 ).
    get_rtti_by_type_kind_assert( decfloat34 ).

  ENDMETHOD.

  METHOD get_rtti_by_type_kind_enum.

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

    DATA(rtti) = CAST cl_abap_enumdescr( cl_abap_typedescr=>describe_by_name( 'ENUM_SIZE' ) ).

    TRY.
        NEW ltc_subclass( rtti )->get_rtti_by_type_kind_2( rtti->type_kind ).
      CATCH cx_root INTO DATA(lx).
    ENDTRY.
    cl_abap_unit_assert=>assert_bound( lx ).

  ENDMETHOD.

ENDCLASS.
