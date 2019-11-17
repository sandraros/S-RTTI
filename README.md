# S-RTTI
Serialization and deserialization of RTTI object

Demo program:
```
" Serialization
DATA variable TYPE c LENGTH 20.
variable = 'Hello world'.
DATA(srtti) = zcl_srtti_typedescr=>create_by_data_object( variable ).
CALL TRANSFORMATION ID SOURCE srtti = srtti dobj = variable RESULT XML DATA(xstring).

" Deserialization
DATA: srtti2       TYPE REF TO zcl_srtti_typedescr,
      ref_variable TYPE REF TO DATA.
CALL TRANSFORMATION ID SOURCE XML xstring RESULT srtti = srtti2.
DATA(rtti) = srtti2->get_rtti( ).
CREATE DATA ref_variable TYPE HANDLE rtti.
ASSIGN ref_variable->* TO FIELD-SYMBOL(<variable>).
CALL TRANSFORMATION ID SOURCE XML xstring RESULT dobj = <variable>.
ASSERT <variable> = 'Hello world'.
```
