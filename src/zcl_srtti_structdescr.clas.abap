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

    DATA struct_kind LIKE cl_abap_structdescr=>struct_kind .
    DATA components TYPE zcl_srtti_structdescr=>sabap_component_tab .
*    DATA components LIKE cl_abap_structdescr=>components .
    DATA has_include LIKE cl_abap_structdescr=>has_include .
*    DATA loc_components TYPE abap_component_tab .

    METHODS constructor
      IMPORTING
        !rtti        TYPE REF TO cl_abap_structdescr.
    METHODS get_rtti
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SRTTI_STRUCTDESCR IMPLEMENTATION.


  METHOD constructor.

    SUPER->constructor( rtti ).
    struct_kind = rtti->struct_kind.
*    components  = rtti->components.
    has_include = rtti->has_include.

    LOOP AT rtti->get_components( ) ASSIGNING FIELD-SYMBOL(<component>).
      DATA(scomponent) = VALUE sabap_componentdescr(
          name       = <component>-name
          type       = NEW zcl_srtti_datadescr( <component>-type )
          as_include = <component>-as_include
          suffix     = <component>-suffix ).
      APPEND scomponent TO components.
      IF scomponent-type->not_serializable = abap_true.
        not_serializable = abap_true.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_rtti.

    data(lt_component) = value cl_abap_structdescr=>component_table( ).
    LOOP AT components ASSIGNING FIELD-SYMBOL(<component>).
      data(ls_component) = value abap_componentdescr(
      name       = <component>-name
      type       = CAST #( <component>-type->GET_rtti( ) )
      as_include = <component>-as_include
      suffix     = <component>-suffix ).
      APPEND ls_component TO lt_component.
    ENDLOOP.
    rtti = cl_abap_structdescr=>create( lt_component ).


  ENDMETHOD.
ENDCLASS.
