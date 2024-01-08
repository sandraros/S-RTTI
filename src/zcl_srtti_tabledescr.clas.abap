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

    DATA temp1 TYPE abap_keydescr_tab.
    DATA empty_key LIKE temp1.
        DATA temp2 TYPE REF TO cl_abap_datadescr.
        DATA error TYPE REF TO cx_sy_table_creation.
    CLEAR temp1.

    empty_key = temp1.
    CASE key_defkind.
      WHEN cl_abap_tabledescr=>keydefkind_user.
        ASSIGN key TO <lt_key>.
      WHEN OTHERS.
        ASSIGN empty_key TO <lt_key>.
    ENDCASE.
    TRY.

        temp2 ?= line_type->get_rtti( ).
        rtti = cl_abap_tabledescr=>create(
            p_line_type   = temp2
            p_table_kind  = table_kind
            p_unique      = has_unique_key
            p_key         = <lt_key>
            p_key_kind    = key_defkind ).

      CATCH cx_sy_table_creation INTO error.
        RAISE EXCEPTION TYPE zcx_srtti EXPORTING previous = error.
    ENDTRY.

  ENDMETHOD.

  METHOD constructor.
    DATA temp3 TYPE REF TO zcl_srtti_datadescr.

    SUPER->constructor( rtti ).
    key             = rtti->key.
    initial_size    = rtti->initial_size.
    key_defkind     = rtti->key_defkind.
    has_unique_key  = rtti->has_unique_key.
    table_kind      = rtti->table_kind.

    temp3 ?= zcl_srtti_typedescr=>create_by_rtti( rtti->get_table_line_type( ) ).
    line_type       = temp3.
    IF line_type->not_serializable = abap_true.
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
