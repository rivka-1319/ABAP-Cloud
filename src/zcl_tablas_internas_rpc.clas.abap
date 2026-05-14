CLASS zcl_tablas_internas_rpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tablas_internas_rpc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " TABLAS INTERNAS SIMPLES
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lv_numero TYPE i VALUE 19.


    "1. Creación de la tabla
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_numeros TYPE TABLE OF i.


    "2. Añadir valores a la tabla con APPEND
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND 19 TO lt_numeros.
    APPEND lv_numero TO lt_numeros.
    APPEND 2 * lv_numero TO lt_numeros.


    "3. 'CLEAR <table-name>' elimina el contenido de una tabla
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    "4. Extracción de un valor seleccionado
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(lv_segunda_pos) = lt_numeros[ 2 ].


    "5. Lectura de la tabla con LOOP AT INTO
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    LOOP AT lt_numeros INTO DATA(lv_num).
      out->write( |{ lv_num } | ).
    ENDLOOP.


    "6. Usando 'sy-tabix' podemos saber el índice del elemento
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    LOOP AT lt_numeros INTO lv_num.
      out->write( |Fila { sy-tabix }: { lv_num } | ).
    ENDLOOP.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "APUNTES CLASE
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    "1. Tablas internas STANDARD"
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    TYPES:BEGIN OF ty_empleado,
            nombre   TYPE string,
            edad     TYPE i,
            telefono TYPE string,
            correo   TYPE string,
          END OF ty_empleado.

    DATA ls_empleado TYPE ty_empleado.
    "1.1 A menos que se indique el tipo de tabla, será estándar
    "por defecto
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado TYPE STANDARD TABLE OF ty_empleado.
    DATA lt_empleado2 TYPE TABLE OF ty_empleado.


    "2. Tablas internas SORTED - uso para acceder a la info
    "Puede ser UNIQUE y NON-UNIQUE
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_sorted TYPE SORTED TABLE OF ty_empleado WITH UNIQUE KEY correo.


    "3. Tablas internas HASH - búsqueda rápida de información
    "Solo puede ser UNIQUE
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_hashed TYPE HASHED TABLE OF  ty_empleado WITH UNIQUE KEY correo.


    "4. Inserción de elemento
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'Rebeca'.
    ls_empleado-edad = 23.
    ls_empleado-telefono = '123456789'.
    ls_empleado-correo = 'rebeca@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 1.


    "5. Modificar los valores para introducirlos en un nuevo índice
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'María'.
    ls_empleado-edad = 48.
    ls_empleado-telefono = '123456789'.
    ls_empleado-correo = 'maria@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 2.


    "6.Si volviera a insertar en INDEX 2, el resto de la tabla se
    "desplaza hacia abajo
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'Carlos'.
    ls_empleado-edad = 21.
    ls_empleado-telefono = '123456789'.
    ls_empleado-correo = 'carlos@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 2.


    "7.Si no indicas el INDEX se añade en la siguiente línea vacía
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'Javier'.
    ls_empleado-edad = 58.
    ls_empleado-telefono = '123456789'.
    ls_empleado-correo = 'javier@gmail.com'.

    INSERT ls_empleado INTO TABLE lt_empleado.


    "8.LOOP AT
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    LOOP AT lt_empleado INTO ls_empleado.
      out->write( |Nombre: {  ls_empleado-nombre }, edad: { ls_empleado-edad } | ).
    ENDLOOP.


    "9.Operaciones con tablas
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*        "Linea en blanco: insert initial line into table lt_cliente
*        out->write( lt_cliente ).
*
*        "Copiado de tablas (no se suele hacer)
*        DATA lt_cliente2 LIKE lt_cliente.
*
*        "Duplicidad de contenido
*        INSERT LINES OF lt_cliente INTO TABLE lt_cliente2.
*
*        "Duplicidad hasta X registro
*        INSERT LINES OF lt_cliente TO 1 INTO TABLE lt_cliente2.
*
*        "Duplicidad de X registros
*        INSERT LINES OF lt_cliente FROM 1 TO 2 INTO TABLE lt_cliente2.
*
*        out->write( lt_cliente2 ).


    "10.Ejercicio - Filtrado e ID automático
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado = VALUE #( nombre = 'Mario' edad = 23 telefono = '+34111223344' correo = 'mario@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Celia' edad = 30 telefono = '+34111223344' correo = 'celia@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Inma' edad = 54 telefono = '+34111223344' correo = 'inmaculada@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Gabriel' edad = 23 telefono = '+34111223344' correo = 'celia@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    out->write( |{ cl_abap_char_utilities=>cr_lf }| ).
    out->write( |Ejercicio filtro| ).

    TYPES:BEGIN OF ty_empleado_filtro,
            id     TYPE i,
            nombre TYPE string,
            edad   TYPE i,
          END OF ty_empleado_filtro.

    DATA lt_empleado_filtro TYPE TABLE OF ty_empleado_filtro.
    DATA lv_cont TYPE i VALUE 1.

    LOOP AT lt_empleado INTO ls_empleado.
      IF ls_empleado-edad = 23.
        INSERT VALUE #( id = lv_cont nombre = ls_empleado-nombre edad = ls_empleado-edad ) INTO TABLE lt_empleado_filtro.
        lv_cont += 1.
      ENDIF.
    ENDLOOP.

    out->write( lt_empleado_filtro ).

  ENDMETHOD.
ENDCLASS.
