"! <p class="shorttext synchronized" lang="en">Serializable RTTI table</p>
class ZCL_SRTTI_TABLEDESCR definition
  public
  inheriting from ZCL_SRTTI_COMPLEXDESCR
  create public .

public section.

  data KEY like CL_ABAP_TABLEDESCR=>KEY .
  data INITIAL_SIZE like CL_ABAP_TABLEDESCR=>INITIAL_SIZE .
  data KEY_DEFKIND like CL_ABAP_TABLEDESCR=>KEY_DEFKIND .
  data HAS_UNIQUE_KEY like CL_ABAP_TABLEDESCR=>HAS_UNIQUE_KEY .
  data TABLE_KIND like CL_ABAP_TABLEDESCR=>TABLE_KIND .
  data LINE_TYPE type ref to ZCL_SRTTI_DATADESCR .

  methods CONSTRUCTOR
    importing
      !RTTI type ref to CL_ABAP_TABLEDESCR .

  methods GET_RTTI
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SRTTI_TABLEDESCR IMPLEMENTATION.


  METHOD constructor.

    SUPER->constructor( rtti ).
    key             = rtti->key.
    initial_size    = rtti->initial_size.
    key_defkind     = rtti->key_defkind.
    has_unique_key  = rtti->has_unique_key.
    table_kind      = rtti->table_kind.
    line_type       = cast #( zcl_srtti_typedescr=>create_by_rtti( rtti->get_table_line_type( ) ) ).
    IF line_type->not_serializable = abap_true.
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.


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
    TRY.
        rtti = cl_abap_tabledescr=>create(
            p_line_type   = CAST #( line_type->get_rtti( ) )
            p_table_kind  = table_kind
            p_unique      = has_unique_key
            p_key         = <lt_key>
            p_key_kind    = key_defkind ).
      CATCH cx_sy_table_creation INTO DATA(error).
        RAISE EXCEPTION TYPE zcx_srtti EXPORTING previous = error.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
