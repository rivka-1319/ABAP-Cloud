CLASS zcl_auto_id_rpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_auto_id_rpc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "EJERCICIO PRÁCTICO
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA: ls_auto_id  TYPE zdb_auto_id_rpc,
          lv_registro TYPE i VALUE 1,
          lv_random   TYPE REF TO cl_abap_random_int,
          lv_max_id   TYPE i,
          lv_repetido TYPE i VALUE 0.

    "MAX( id ) - ID más alto previo a una línea vacía
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    SELECT MAX( id ) FROM zdb_auto_id_rpc INTO @lv_max_id.

    "Inserción nuevo nombre
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(lv_nuevo_nombre) = 'Gonzalo Portillo'.

    "Comprobación nombre no repetido
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    SELECT * FROM zdb_auto_id_rpc INTO TABLE @DATA(lt_auto_id).
    LOOP AT lt_auto_id INTO ls_auto_id.
      IF ls_auto_id-nombre EQ lv_nuevo_nombre.
        lv_repetido = 1.
        EXIT.
      ENDIF.
    ENDLOOP.

    "Comprobación de válidez de datos e inserción
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    IF lv_repetido EQ 0.

      IF lv_max_id IS INITIAL OR lv_max_id = 0.
        lv_max_id = 1.
      ELSE.
        lv_max_id += 1.
      ENDIF.

      ls_auto_id-id = lv_max_id.
      ls_auto_id-nombre = lv_nuevo_nombre.
      out->write( |Se ha introducido en la BBDD exitosamente| ).
      INSERT zdb_auto_id_rpc FROM @ls_auto_id.

    ELSE.
      lv_max_id = 1.
      out->write( |No se ha podido insertar en la BBDD| ).
      out->write( |Motivo: el campo "nombre" ya existe| ).

    ENDIF.

    "Obtención de registro aleatorio
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lv_random = cl_abap_random_int=>create(
                seed = cl_abap_random=>seed( )
                min  = 1
                max  = lv_max_id ).

    lv_registro = lv_random->get_next( ).

    "Impresión del registro aleatorio
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "INSERT solo funciona entre tablas internas o de una tabla interna a una BBDD
    SELECT * FROM zdb_auto_id_rpc INTO TABLE @lt_auto_id.
    out->write( lt_auto_id[ lv_registro ] ).

*    DELETE FROM zdb_auto_id_rpc.

  ENDMETHOD.
ENDCLASS.
