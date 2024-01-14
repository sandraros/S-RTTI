"! <p class="shorttext synchronized" lang="en">Serializable RTTI object type</p>
CLASS zcl_srtti_objectdescr DEFINITION
  PUBLIC
  INHERITING FROM zcl_srtti_typedescr
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA interfaces LIKE cl_abap_objectdescr=>interfaces .
    DATA types LIKE cl_abap_objectdescr=>types .
    DATA attributes LIKE cl_abap_objectdescr=>attributes .
    DATA methods LIKE cl_abap_objectdescr=>methods .
    DATA events LIKE cl_abap_objectdescr=>events .

    METHODS constructor
      IMPORTING
        !rtti TYPE REF TO cl_abap_objectdescr.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SRTTI_OBJECTDESCR IMPLEMENTATION.


  METHOD constructor.
    DATA temp1 LIKE sy-subrc.

    super->constructor( rtti ).
    interfaces  = rtti->interfaces.
    types       = rtti->types.
    attributes  = rtti->attributes.
    methods     = rtti->methods.
    events      = rtti->events.

    READ TABLE interfaces WITH KEY name = 'IF_SERIALIZABLE_OBJECT' TRANSPORTING NO FIELDS.
    temp1 = sy-subrc.
    IF NOT temp1 = 0.
      not_serializable = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
