CLASS zcl_clase_rpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_clase_rpc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


    "Declaración de variables

    DATA lv_numero TYPE d VALUE '208870428'.

    "Declaración agrupada de variables

    data: lv_perro TYPE string VALUE 'Firulais',
        "  lv_gato type string,
          lv_raton type string.

    data: lv_sofa type string,
          lv_mesa TYPE string,
          lv_cama TYPE string.

    "Declaración de variables en línea

    data(lv_gato) = 'Garfield'.




    " TIPOS DE VARIABLES "



    " TIPOS COMPLETOS "

    "Fechas "AAAAA-MM-DD"
    DATA lv_d TYPE d VALUE '20260512'.

    "Tiempo hhmmss"
    DATA lv_t TYPE t VALUE '095513'.

    "i almacena hasta 4 bytes de información
    DATA lv_int type i.

    "f equivale a float
    DATA lv_float type f.

    "String tipo para cadena de caracteres, es dinámico
    DATA lv_string type string.



    " TIPOS INCOMPLETOS (uso de length)"

    " C tipo para cadena de caracteres (longitud: 1 - 65535). Los valores siempre entre comillas simples
    DATA lv_c TYPE c LENGTH 20 VALUE 'Experis'.

    " N tipo de cadena de caracteres numerica (longitud: 1 - 65535)


    " X tipo para cadena hexadecimal


    " P tipo para números empaquetado 1 a 16 bytes
    DATA lv_p TYPE p LENGTH 8 DECIMALS 2 VALUE '202501.10'.
    DATA lv_decimal TYPE p LENGTH 3 DECIMALS 2.


    lv_int = 7.

    out->write( lv_int ).


  ENDMETHOD.

ENDCLASS.
