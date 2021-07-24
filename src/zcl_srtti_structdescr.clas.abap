"! <p class="shorttext synchronized" lang="en">Serializable RTTI structure</p>
CLASS zcl_srtti_structdescr DEFINITION
  PUBLIC
  INHERITING FROM zcl_srtti_complexdescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF sabap_componentdescr,
        name       TYPE string,
        type       TYPE REF TO zcl_srtti_datadescr,
        as_include TYPE abap_bool,
        suffix     TYPE string,
      END OF sabap_componentdescr .
    TYPES:
      sabap_component_tab TYPE STANDARD TABLE OF sabap_componentdescr .

    DATA struct_kind LIKE cl_abap_structdescr=>struct_kind READ-ONLY.
    DATA components  TYPE sabap_component_tab READ-ONLY.
    DATA has_include LIKE cl_abap_structdescr=>has_include READ-ONLY.

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_structdescr.
    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_structdescr IMPLEMENTATION.


  METHOD constructor.

    super->constructor( rtti ).

    struct_kind = rtti->struct_kind.
    has_include = rtti->has_include.

    LOOP AT rtti->get_components( ) ASSIGNING FIELD-SYMBOL(<component>).
      DATA(scomponent) = VALUE sabap_componentdescr(
          name       = <component>-name
          type       = CAST #( zcl_srtti_datadescr=>create_by_rtti( <component>-type ) )
          as_include = <component>-as_include
          suffix     = <component>-suffix ).
      APPEND scomponent TO components.
      IF scomponent-type->not_serializable = abap_true.
        not_serializable = abap_true.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_rtti.

    DATA(lt_component) = VALUE cl_abap_structdescr=>component_table( ).
    LOOP AT components ASSIGNING FIELD-SYMBOL(<component>).
      DATA(ls_component) = VALUE abap_componentdescr(
      name       = <component>-name
      type       = CAST #( <component>-type->get_rtti( ) )
      as_include = <component>-as_include
      suffix     = <component>-suffix ).
      APPEND ls_component TO lt_component.
    ENDLOOP.
    rtti = cl_abap_structdescr=>create( lt_component ).

  ENDMETHOD.


ENDCLASS.
