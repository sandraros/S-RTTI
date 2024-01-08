CLASS zcl_srtti_apack DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES zif_apack_manifest.
    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_srtti_apack IMPLEMENTATION.

  METHOD constructor.

*    zif_apack_manifest~descriptor-group_id = 'github.com/sandraros'.
*    zif_apack_manifest~descriptor-artifact_id  = 'S-RTTI'.
*    zif_apack_manifest~descriptor-version      = '1.0'.
*    zif_apack_manifest~descriptor-repository_type = 'abapGit'.
*    zif_apack_manifest~descriptor-git_url      = 'https://github.com/sandraros/S-RTTI.git'.
*    CLEAR  zif_apack_manifest~descriptor-dependencies.

  ENDMETHOD.

ENDCLASS.
