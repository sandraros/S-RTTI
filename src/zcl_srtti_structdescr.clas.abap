"! <p class="shorttext synchronized" lang="en">Serializable RTTI structure</p>
class ZCL_SRTTI_STRUCTDESCR definition
  public
  inheriting from ZCL_SRTTI_COMPLEXDESCR
  create public .

public section.

  types:
    BEGIN OF sabap_componentdescr,
        name       TYPE string,
        type       TYPE REF TO zcl_srtti_datadescr,
        as_include TYPE abap_bool,
        suffix     TYPE string,
      END OF sabap_componentdescr .
  types:
    sabap_component_tab TYPE STANDARD TABLE OF sabap_componentdescr WITH DEFAULT KEY .

  data STRUCT_KIND like CL_ABAP_STRUCTDESCR=>STRUCT_KIND read-only .
  data COMPONENTS type SABAP_COMPONENT_TAB read-only .
  data HAS_INCLUDE like CL_ABAP_STRUCTDESCR=>HAS_INCLUDE read-only .

  methods CONSTRUCTOR
    importing
      !RTTI type ref to CL_ABAP_STRUCTDESCR .

  methods GET_RTTI
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SRTTI_STRUCTDESCR IMPLEMENTATION.


  METHOD constructor.
    DATA components_rtti TYPE abap_component_tab.
    DATA scomponent      TYPE sabap_componentdescr.
    DATA scomponent_rtti TYPE REF TO zcl_srtti_datadescr.

    FIELD-SYMBOLS <component> TYPE abap_componentdescr.

    super->constructor( rtti ).

    struct_kind = rtti->struct_kind.
    has_include = rtti->has_include.

    components_rtti = rtti->get_components( ).

    LOOP AT components_rtti ASSIGNING <component>.

      CLEAR scomponent.
      scomponent-name = <component>-name.

      scomponent_rtti ?= zcl_srtti_datadescr=>create_by_rtti( <component>-type ).
      scomponent-type       = scomponent_rtti.
      scomponent-as_include = <component>-as_include.
      scomponent-suffix     = <component>-suffix.

      APPEND scomponent TO components.
      IF scomponent-type->not_serializable = abap_true.
        not_serializable = abap_true.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_rtti.
    DATA components_rtti TYPE cl_abap_structdescr=>component_table.
    DATA component_rtti  TYPE abap_componentdescr.

    FIELD-SYMBOLS <component> TYPE sabap_componentdescr.

    CLEAR components_rtti.
    LOOP AT components ASSIGNING <component>.

      CLEAR component_rtti.
      component_rtti-name        = <component>-name.
      component_rtti-type       ?= <component>-type->get_rtti( ).
      component_rtti-as_include  = <component>-as_include.
      component_rtti-suffix      = <component>-suffix.

      APPEND component_rtti TO components_rtti.
    ENDLOOP.
    rtti = cl_abap_structdescr=>create( components_rtti ).
  ENDMETHOD.
ENDCLASS.
