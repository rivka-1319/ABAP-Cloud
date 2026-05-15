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
    out->write( |  | ).
    out->write( | 4. Uso de LOOP AT INTO | ).
    LOOP AT lt_numeros INTO DATA(lv_num).
      out->write( |{ lv_num } | ).
    ENDLOOP.


    "6. Usando 'sy-tabix' podemos saber el índice del elemento
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    out->write( |  | ).
    out->write( | 6. Uso de sy-tabix | ).
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
    ls_empleado-telefono = '+34123456789'.
    ls_empleado-correo = 'rebeca@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 1.


    "5. Modificar los valores para introducirlos en un nuevo índice
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'María'.
    ls_empleado-edad = 48.
    ls_empleado-telefono = '+34123456789'.
    ls_empleado-correo = 'maria@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 2.


    "6.Si volviera a insertar en INDEX 2, el resto de la tabla se
    "desplaza hacia abajo
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'Carlos'.
    ls_empleado-edad = 21.
    ls_empleado-telefono = '+34123456789'.
    ls_empleado-correo = 'carlos@gmail.com'.

    INSERT ls_empleado INTO lt_empleado INDEX 2.


    "7.Si no indicas el INDEX se añade en la siguiente línea vacía
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ls_empleado-nombre = 'Javier'.
    ls_empleado-edad = 58.
    ls_empleado-telefono = '+34123456789'.
    ls_empleado-correo = 'javier@gmail.com'.

    INSERT ls_empleado INTO TABLE lt_empleado.


    "8.LOOP AT
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    out->write( |  | ).
    out->write( | 8. LOOP AT INTO - Explicación de clase | ).
    LOOP AT lt_empleado INTO ls_empleado.
      out->write( |Nombre: {  ls_empleado-nombre }, edad: { ls_empleado-edad } | ).
    ENDLOOP.


    "10.Ejercicio - Filtrado e ID automático
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    out->write( |  | ).
    out->write( | 10. Ejercicio filtro | ).

    ls_empleado = VALUE #( nombre = 'Mario' edad = 23 telefono = '+34111223344' correo = 'mario@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Celia' edad = 30 telefono = '+34111223344' correo = 'celia@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Inma' edad = 54 telefono = '+34111223344' correo = 'inmaculada@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    ls_empleado = VALUE #( nombre = 'Gabriel' edad = 23 telefono = '+34111223344' correo = 'gabriel@gmail.com' ).
    INSERT ls_empleado INTO TABLE lt_empleado.

    out->write( |  | ).
    out->write( | 10.1 Tabla sin filtro | ).
    out->write( lt_empleado ).

    TYPES:BEGIN OF ty_empleado_filtro,
            id     TYPE i,
            nombre TYPE string,
            edad   TYPE i,
          END OF ty_empleado_filtro.

    DATA lt_empleado_filtro TYPE TABLE OF ty_empleado_filtro.
    DATA lv_cont TYPE i VALUE 1.

    out->write( |  | ).
    out->write( | 10.2 Tabla con filtro e ID automático | ).
    LOOP AT lt_empleado INTO ls_empleado.
      IF ls_empleado-edad = 23.
        INSERT VALUE #( id = lv_cont nombre = ls_empleado-nombre edad = ls_empleado-edad ) INTO TABLE lt_empleado_filtro.
        lv_cont += 1.
      ENDIF.
    ENDLOOP.

    out->write( lt_empleado_filtro ).


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "OPERACIONES CON TABLAS
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    "11. Resgistros vacíos
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    INSERT INITIAL LINE INTO TABLE lt_empleado.


    "12. LIKE - Copia de estructura vacía (encabezado)
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA ty_empleado_copia TYPE TABLE OF ty_empleado.
    DATA lt_empleado_copia LIKE lt_empleado.


    "13. INSERT LINES OF - Copia datos entre tablas
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_duplicado TYPE TABLE OF ty_empleado.
    INSERT LINES OF lt_empleado INTO TABLE lt_empleado_duplicado.


    "14. INSERT LINES OF TO - Copia una fila en otra tabla
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_fila TYPE TABLE OF ty_empleado.
    INSERT LINES OF lt_empleado TO 1 INTO TABLE lt_empleado_fila.


    "15. INSERT LINES FROM TO - Copiar un rango de filas en otra tabla
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    INSERT LINES OF lt_empleado FROM 2 TO 4 INTO TABLE lt_empleado_fila.


    "16. APPEND - recomendado usar INSERT
    "Inserta automáticamente el contenido en la última fila
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_append TYPE TABLE OF ty_empleado.
    APPEND ls_empleado TO lt_empleado_append.


    "17. APPEND - insertar valores
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND VALUE #( nombre = 'David' edad = 35 telefono = '+34111223344' correo = 'david@gmail.com' ) TO lt_empleado.


    "18. Inserción de valores - forma MODERNA
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lt_empleado_moderno TYPE TABLE OF ty_empleado.
    lt_empleado_moderno = VALUE #(
    ( nombre = 'Marta' edad = 71 telefono = '+34111223344' correo = 'marta@gmail.com' )
    ( nombre = 'Juan' edad = 45 telefono = '+34111223344' correo = 'juan@gmail.com' )
    ( nombre = 'Santiago' edad = 27 telefono = '+34111223344' correo = 'santiago@gmail.com' )
    ).


  ENDMETHOD.
ENDCLASS.
