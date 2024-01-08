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

    if_apack_manifest~descriptor-group_id = 'github.com/sandraros'.
    if_apack_manifest~descriptor-artifact_id  = 'S-RTTI'.
    if_apack_manifest~descriptor-version      = '1.0'.
    if_apack_manifest~descriptor-repository_type = 'abapGit'.
    if_apack_manifest~descriptor-git_url      = 'https://github.com/sandraros/S-RTTI.git'.
    CLEAR  if_apack_manifest~descriptor-dependencies.

  ENDMETHOD.

ENDCLASS.
