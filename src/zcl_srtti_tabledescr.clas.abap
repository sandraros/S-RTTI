"! <p class="shorttext synchronized" lang="en">Serializable RTTI table</p>
CLASS zcl_srtti_tabledescr DEFINITION
  PUBLIC
  INHERITING FROM zcl_srtti_complexdescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA key LIKE cl_abap_tabledescr=>key .
    DATA initial_size LIKE cl_abap_tabledescr=>initial_size .
    DATA key_defkind LIKE cl_abap_tabledescr=>key_defkind .
    DATA has_unique_key LIKE cl_abap_tabledescr=>has_unique_key .
    DATA table_kind LIKE cl_abap_tabledescr=>table_kind .
    DATA line_type TYPE REF TO zcl_srtti_datadescr .

    METHODS constructor
      IMPORTING
        !rtti        TYPE REF TO cl_abap_tabledescr.
    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_tabledescr IMPLEMENTATION.


  METHOD get_rtti.

    FIELD-SYMBOLS:
          <lt_key>      TYPE abap_keydescr_tab.

    DATA(empty_key) = VALUE abap_keydescr_tab( ).
    CASE key_defkind.
      WHEN cl_abap_tabledescr=>keydefkind_user.
        ASSIGN key TO <lt_key>.
      WHEN OTHERS.
        ASSIGN empty_key TO <lt_key>.
    ENDCASE.
    rtti = cl_abap_tabledescr=>create(
        p_line_type   = CAST #( line_type->get_rtti( ) )
        p_table_kind  = table_kind
        p_unique      = has_unique_key
        p_key         = <lt_key>
        p_key_kind    = key_defkind ).

  ENDMETHOD.

  METHOD constructor.

    SUPER->constructor( rtti ).
    key             = rtti->key.
    initial_size    = rtti->initial_size.
    key_defkind     = rtti->key_defkind.
    has_unique_key  = rtti->has_unique_key.
    table_kind      = rtti->table_kind.
    line_type       = NEW zcl_srtti_datadescr( rtti->get_table_line_type( ) ).
    IF line_type->not_serializable = abap_true.
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
