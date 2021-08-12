CLASS zcl_srtti_apack DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apack_manifest.

    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_apack IMPLEMENTATION.

  METHOD constructor.

    if_apack_manifest~descriptor = VALUE #(
        group_id     = 'github.com/sandraros'
        artifact_id  = 'S-RTTI'
        version      = '1.0'
        repository_type = 'abapGit'
        git_url      = 'https://github.com/sandraros/S-RTTI.git'
        dependencies = VALUE #( ) ).

  ENDMETHOD.

ENDCLASS.
