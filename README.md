# S-RTTI
Serialization and deserialization of RTTI object

Serialization program:
```
DATA(rtti) = cl_abap_elemdescr=>get_c( 20 ).
DATA ref_variable TYPE REF TO DATA.
CREATE DATA ref_variable TYPE HANDLE rtti.
ASSIGN ref_variable->* TO FIELD-SYMBOL(<variable>).
<variable> = 'Hello world'.
DATA(srtti) = zcl_srtti_typedescr=>serialize( cl_abap_typedescr=>describe_by_data( <variable> ) ).
CALL TRANSFORMATION ID SOURCE srtti = srtti dobj = <variable> RESULT XML DATA(xstring).
```

Deserialization program:
```
DATA srtti TYPE REF TO zcl_srtti_typedescr.
CALL TRANSFORMATION ID SOURCE XML xstring RESULT srtti = srtti.
DATA(rtti) = srtti->deserialize( ).
DATA ref_variable TYPE REF TO DATA.
CREATE DATA ref_variable TYPE HANDLE rtti.
ASSIGN ref_variable->* TO FIELD-SYMBOL(<variable>).
CALL TRANSFORMATION ID SOURCE XML xstring RESULT dobj = <variable>.
ASSERT <variable> = 'Hello world'.
```
