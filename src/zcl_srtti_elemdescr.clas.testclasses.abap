*"* use this source file for your ABAP unit test classes

class ltc_main definition
      for testing
      duration short
      risk level harmless.

  private section.
    methods test for testing.
    DATA dref type ref to data.

endclass.

class ltc_main implementation.

  method test.
    CREATE DATA dref TYPE c LENGTH 10.
    DATA(rtti) = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_data_ref( dref ) ).
    DATA(srtti) = NEW zcl_srtti_elemdescr( CAST #( cl_abap_typedescr=>describe_by_data_ref( dref ) ) ).
* edit_mask.
* help_id.
* output_length.
    cl_abap_unit_assert=>assert_equals( msg = 'Type kind' exp = rtti->type_kind act = srtti->type_kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'Kind' exp = rtti->kind act = srtti->kind ).
  endmethod.

endclass.
