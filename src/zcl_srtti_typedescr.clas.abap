"! <p class="shorttext synchronized" lang="en">Serializable RTTI any type</p>
CLASS zcl_srtti_typedescr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .

    DATA:
      absolute_name    LIKE cl_abap_typedescr=>absolute_name READ-ONLY,
      type_kind        LIKE cl_abap_typedescr=>type_kind READ-ONLY,
      length           LIKE cl_abap_typedescr=>length READ-ONLY,
      decimals         LIKE cl_abap_typedescr=>decimals READ-ONLY,
      kind             LIKE cl_abap_typedescr=>kind READ-ONLY,
      "! True if it's an object type which doesn't implement the interface IF_SERIALIZABLE_OBJECT
      not_serializable TYPE abap_bool READ-ONLY,
      is_ddic_type     TYPE abap_bool READ-ONLY,
      "! True if the absolute name is %_T...
      technical_type   TYPE abap_bool READ-ONLY.

    METHODS constructor
      IMPORTING
        rtti TYPE REF TO cl_abap_typedescr .
    METHODS get_rtti
      RETURNING
        VALUE(rtti) TYPE REF TO cl_abap_typedescr.
    CLASS-METHODS create_by_rtti
      IMPORTING
        rtti         TYPE REF TO cl_abap_typedescr
      RETURNING
        VALUE(srtti) TYPE REF TO zcl_srtti_typedescr.
    CLASS-METHODS create_by_data_object
      IMPORTING
        data_object  TYPE any
      RETURNING
        VALUE(srtti) TYPE REF TO zcl_srtti_typedescr.
  PROTECTED SECTION.
  PRIVATE SECTION.

*    TYPES:
*      BEGIN OF ty_is_repository,
*        o_type     TYPE REF TO cl_abap_typedescr,
*        o_loc_type TYPE REF TO zcl_srtti_typedescr,
*      END OF ty_is_repository .
*
*    CLASS-DATA:
*      kit_repository TYPE TABLE OF ty_is_repository .
ENDCLASS.



CLASS zcl_srtti_typedescr IMPLEMENTATION.


  METHOD constructor.

    absolute_name = rtti->absolute_name.
    type_kind     = rtti->type_kind.
    length        = rtti->length.
    decimals      = rtti->decimals.
    kind          = rtti->kind.
    is_ddic_type  = rtti->is_ddic_type( ).
    IF rtti->absolute_name CP '\TYPE=%_T*'.
      technical_type = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD create_by_rtti.
          DATA temp1 TYPE REF TO cl_abap_enumdescr.
          DATA temp2 TYPE REF TO cl_abap_elemdescr.
        DATA temp3 TYPE REF TO cl_abap_structdescr.
        DATA temp4 TYPE REF TO cl_abap_tabledescr.
        DATA temp5 TYPE REF TO cl_abap_refdescr.
        DATA temp6 TYPE REF TO cl_abap_classdescr.
        DATA temp7 TYPE REF TO cl_abap_intfdescr.

    CASE rtti->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        IF rtti->type_kind = cl_abap_typedescr=>typekind_enum.
          
          temp1 ?= rtti.
          CREATE OBJECT srtti TYPE zcl_srtti_enumdescr EXPORTING RTTI = temp1.
        ELSE.
          
          temp2 ?= rtti.
          CREATE OBJECT srtti TYPE zcl_srtti_elemdescr EXPORTING RTTI = temp2.
        ENDIF.
      WHEN cl_abap_typedescr=>kind_struct.
        
        temp3 ?= rtti.
        CREATE OBJECT srtti TYPE zcl_srtti_structdescr EXPORTING RTTI = temp3.
      WHEN cl_abap_typedescr=>kind_table.
        
        temp4 ?= rtti.
        CREATE OBJECT srtti TYPE zcl_srtti_tabledescr EXPORTING RTTI = temp4.
      WHEN cl_abap_typedescr=>kind_ref.
        
        temp5 ?= rtti.
        CREATE OBJECT srtti TYPE zcl_srtti_refdescr EXPORTING RTTI = temp5.
      WHEN cl_abap_typedescr=>kind_class.
        
        temp6 ?= rtti.
        CREATE OBJECT srtti TYPE zcl_srtti_classdescr EXPORTING RTTI = temp6.
      WHEN cl_abap_typedescr=>kind_intf.
        
        temp7 ?= rtti.
        CREATE OBJECT srtti TYPE zcl_srtti_intfdescr EXPORTING RTTI = temp7.
      WHEN OTHERS.
        " Unsupported (new ABAP features in the future)
        RAISE EXCEPTION TYPE zcx_srtti.
    ENDCASE.

  ENDMETHOD.


  METHOD create_by_data_object.

    srtti = create_by_rtti( cl_abap_typedescr=>describe_by_data( data_object ) ).

  ENDMETHOD.


  METHOD get_rtti.

    " default behavior
    IF technical_type = abap_false."absolute_name NP '\TYPE=%_T*'.
      rtti = cl_abap_typedescr=>describe_by_name( absolute_name ).
    ENDIF.

  ENDMETHOD.


ENDCLASS.
