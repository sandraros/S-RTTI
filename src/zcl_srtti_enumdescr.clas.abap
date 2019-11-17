"! <p class="shorttext synchronized" lang="en">Serializable RTTI enumeration</p>
CLASS zcl_srtti_enumdescr DEFINITION
  PUBLIC
  INHERITING FROM zcl_srtti_elemdescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: base_type_kind LIKE cl_abap_enumdescr=>base_type_kind READ-ONLY,
          members        LIKE cl_abap_enumdescr=>members READ-ONLY.

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_enumdescr .

    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_enumdescr IMPLEMENTATION.


  METHOD constructor.

    super->constructor( rtti ).

    base_type_kind = rtti->base_type_kind.
    members = rtti->members.

  ENDMETHOD.


  METHOD get_rtti.

    DATA(rtti_elem) = super->get_rtti( ).

    rtti = cl_abap_enumdescr=>get(
        p_base_type = CAST #( rtti_elem )
        p_members   = members ).

  ENDMETHOD.


ENDCLASS.
