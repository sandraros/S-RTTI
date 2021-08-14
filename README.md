# S-RTTI
S-RTTI is a set of Serializable classes which wrap the classes of Run Time Type Services (RTTS).

Objective: if your program has to write the values of variables created at run time via RTTS (`CREATE DATA <data reference> TYPE HANDLE <type description object>`) into a persistent storage or into a XSTRING (and read them), you may also probably want to write and read the types of these variables so that you can restore the variables exactly as they were when you saved the values.

Principle to serialize:
1. Wrap the type description object into a serializable type description object: `DATA(srtti) = zcl_srtti_typedescr=>create_by_rtti( <type description object> ).`
1. Serialize the serializable type description object into a XSTRING variable: `CALL TRANSFORMATION ID SOURCE srtti = srtti RESULT XML DATA(xstring).`

Principle to deserialize:
1. Deserialize the XSTRING variable into a serializable type description object: `CALL TRANSFORMATION ID SOURCE XML xstring RESULT srtti = srtti.`
1. Retrieve the type description object from the serializable type description object: `DATA(rtti) = srtti->get_rtti( ).`

If a type description object has some of its parts based on ABAP Dictionary objects, its deserialization can only work (well) if these objects have not been changed since they were serialized.

Demo program:
```abap
" Serialization of both type and value
DATA variable TYPE c LENGTH 20.
variable = 'Hello world'.
DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( variable ).
CALL TRANSFORMATION ID SOURCE srtti = srtti dobj = variable RESULT XML DATA(xstring).

" Deserialization of type
DATA: srtti2       TYPE REF TO zcl_srtti_typedescr,
      ref_variable TYPE REF TO DATA.
CALL TRANSFORMATION ID SOURCE XML xstring RESULT srtti = srtti2.
DATA(rtti) = srtti2->get_rtti( ).

" Deserialization of value
CREATE DATA ref_variable TYPE HANDLE rtti.
ASSIGN ref_variable->* TO FIELD-SYMBOL(<variable>).
CALL TRANSFORMATION ID SOURCE XML xstring RESULT dobj = <variable>.

" Verify
ASSERT <variable> = 'Hello world'.
```
