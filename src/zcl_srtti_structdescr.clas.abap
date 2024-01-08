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
    DATA temp1 TYPE abap_component_tab.
    FIELD-SYMBOLS <component> LIKE LINE OF temp1.
      DATA temp2 TYPE sabap_componentdescr.
      DATA temp3 TYPE REF TO zcl_srtti_datadescr.
      DATA scomponent LIKE temp2.

    super->constructor( rtti ).

    struct_kind = rtti->struct_kind.
    has_include = rtti->has_include.

    
    temp1 = rtti->get_components( ).
    
    LOOP AT temp1 ASSIGNING <component>.
      
      CLEAR temp2.
      temp2-name = <component>-name.
      
      temp3 ?= zcl_srtti_datadescr=>create_by_rtti( <component>-type ).
      temp2-type = temp3.
      temp2-as_include = <component>-as_include.
      temp2-suffix = <component>-suffix.
      
      scomponent = temp2.
      APPEND scomponent TO components.
      IF scomponent-type->not_serializable = abap_true.
        not_serializable = abap_true.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_rtti.

    DATA temp3 TYPE cl_abap_structdescr=>component_table.
    DATA lt_component LIKE temp3.
    FIELD-SYMBOLS <component> LIKE LINE OF components.
      DATA temp4 TYPE abap_componentdescr.
      DATA temp5 TYPE REF TO cl_abap_datadescr.
      DATA ls_component LIKE temp4.
    CLEAR temp3.
    
    lt_component = temp3.
    
    LOOP AT components ASSIGNING <component>.
      
      CLEAR temp4.
      temp4-name = <component>-name.
      
      temp5 ?= <component>-type->get_rtti( ).
      temp4-type = temp5.
      temp4-as_include = <component>-as_include.
      temp4-suffix = <component>-suffix.
      
      ls_component = temp4.
      APPEND ls_component TO lt_component.
    ENDLOOP.
    rtti = cl_abap_structdescr=>create( lt_component ).

  ENDMETHOD.


ENDCLASS.
