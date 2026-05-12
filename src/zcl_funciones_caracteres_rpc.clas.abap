CLASS zcl_funciones_caracteres_rpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_funciones_caracteres_rpc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "strlen(): Devolución cantidad de caracteres
    DATA(lv_num) = strlen( '  Rebeca  ' ).

    "numofchar() no tiene en cuenta los espacios en blanco.
    "data(lv_num) = numofchar( '  Rebeca  ' ).

    "Count
    DATA lv_var TYPE string VALUE 'Experis Experis'.
    lv_var = count( val = lv_var sub = 'ex' ).

    "COUNT_ANY_OF (diferencia mayúsculas y minúsculas)
    lv_var = count_any_of( val = lv_var sub = 'ex' ).

    "COUNT_ANY_NOT_OF
    lv_var = count_any_not_of( val = lv_var sub = 'ex' ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    lv_var = 'Experis Experis'.

    "FIND, si hay varias devuelve la primera que encuentra
    lv_num = find( val = lv_var sub = 'is' ).

    "FIND_ANY_OF
    lv_num = find_any_of( val = lv_var sub = 'is' ).

    "FIND_ANY_NOT_OF
    lv_num = find_any_not_of( val = lv_var sub = 'is' ).

    out->write( lv_num ).
    out->write( lv_var ).
  ENDMETHOD.
ENDCLASS.
