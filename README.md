# S-RTTI
S-RTTI is a set of Serializable classes which wrap the classes of Run Time Type Services (RTTS).

Objective: if your program has to write the values of variables created at run time via RTTS ([`CREATE DATA <data reference> TYPE HANDLE <type description object>`](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm?file=abapcreate_data_handle.htm)) into a persistent storage or into a XSTRING (and read them), you may also probably want to write and read the types of these variables so that you can restore the variables exactly as they were when you saved the values.

Principle to serialize:
1. Wrap the type description object into a serializable type description object, via either `create_by_rtti`:
   ```abap
   DATA(srtti) = zcl_srtti_typedescr=>create_by_rtti( <type description object> ).
   ```
   or via `create_by_data_object` (with an existing data object, i.e. variable, structure, internal table and so on):
   ```abap
   DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( <variable> ).
   ```
1. Serialize the serializable type description object into a XSTRING variable:
   ```abap
   CALL TRANSFORMATION ID SOURCE srtti = srtti RESULT XML DATA(xstring).
   ```

Principle to deserialize:
1. Deserialize the XSTRING variable into a serializable type description object:
   ```abap
   CALL TRANSFORMATION ID SOURCE XML xstring RESULT srtti = srtti.
   ```
1. Retrieve the type description object from the serializable type description object:
   ```abap
   DATA(rtti) = srtti->get_rtti( ).
   ```
1. Create the data object (no S-RTTI implied here) and manipulate via a field symbol:
   ```abap
   TYPES ty_ref_to_data TYPE REF TO DATA.
   DATA(ref_to_data) = VALUE ty_ref_to_data( ).

   CREATE DATA ref_to_data TYPE HANDLE rtti.
   ASSIGN ref_to_data->* TO FIELD-SYMBOL(<any>).
   ```

If a type description object has some of its parts based on ABAP Dictionary objects, its deserialization can only work (well) if these objects have not been changed since they were serialized.

Demo program:
```abap
TYPES 
" Serialization of both type and value
DATA variable TYPE c LENGTH 20.
variable = 'Hello world'.
DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( variable ).
CALL TRANSFORMATION ID SOURCE srtti = srtti
                              dobj  = variable
                       RESULT XML DATA(xstring).

" HERE, XSTRING CONTAINS BOTH THE VARIABLE VALUE (DOBJ) AND ITS SERIALIZABLE RTTS TYPE DESCRIPTION OBJECT (SRTTI).

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

S-RTTI is known to be used by these repositories:
- [FM-Test-Data](https://github.com/sandraros/FM-Test-Data)
- [abap2UI5](https://github.com/abap2UI5/abap2UI5)
- Please advertise other projects
