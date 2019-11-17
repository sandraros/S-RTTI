CLASS zcl_srtti_aunit DEFINITION
  PUBLIC
  FOR TESTING
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS serialize_deserialize IMPORTING variable TYPE any.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_aunit IMPLEMENTATION.

  METHOD serialize_deserialize.
    " Serialize: both type and value at the same time.
    ASSIGN variable TO FIELD-SYMBOL(<variable1>).
    DATA(rtti1) = cl_abap_typedescr=>describe_by_data( <variable1> ).
    DATA(srtti1) = zcl_srtti_typedescr=>create_by_data_object( <variable1> ).
    CALL TRANSFORMATION id
        SOURCE  srtti = srtti1
                dobj  = <variable1>
        RESULT XML DATA(xstring)
        OPTIONS data_refs = 'heap-or-create'.

    " Deserialize: (1) the type, to create the variable (2) then the value.
    DATA srtti2 TYPE REF TO zcl_srtti_typedescr.
    CALL TRANSFORMATION id
        SOURCE XML xstring
        RESULT srtti = srtti2.
    DATA(rtti2) = CAST cl_abap_datadescr( srtti2->get_rtti( ) ).
    DATA ref_variable2 TYPE REF TO data.
    CREATE DATA ref_variable2 TYPE HANDLE rtti2.
    ASSIGN ref_variable2->* TO FIELD-SYMBOL(<variable2>).
    CALL TRANSFORMATION id
        SOURCE XML xstring
        RESULT dobj = <variable2>.

    cl_abap_unit_assert=>assert_equals( exp = rtti1 act = rtti2 ).
    cl_abap_unit_assert=>assert_equals( exp = <variable1> act = <variable2> ).
  ENDMETHOD.

ENDCLASS.
