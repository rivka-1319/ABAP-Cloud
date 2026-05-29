CLASS zcl_main_vuelos_rpc DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_main_vuelos_rpc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "If x is bound

    DATA lt_pasajeros TYPE STANDARD TABLE OF REF TO zcl_pasajero_rpc.
    DATA(lo_vuelos) = NEW zcl_gestor_vuelos_rpc( ).
    TYPES: BEGIN OF ty_cliente,
             id            TYPE i,
             nombre        TYPE string,
             km_recorridos TYPE f,
           END OF ty_cliente,
           lt_cliente TYPE STANDARD TABLE OF ty_cliente WITH EMPTY KEY.

    "Creación de valores
    DATA(ls_pasajeros_clientes) = VALUE lt_cliente(
    ( id = '001' nombre = 'Rocío' km_recorridos = '3450' )
    ( id = '034' nombre = 'Carlos' km_recorridos = '46874' )
    ( id = '081' nombre = 'María' km_recorridos = '561' )
     ).

    LOOP AT ls_pasajeros_clientes INTO DATA(ls_cliente).

      CASE ls_cliente-id.
        WHEN '001'.
          " Insertamos a Rocío
          INSERT NEW zcl_pasajero_rpc(
            iv_id                    = ls_cliente-id
            iv_nombre                = ls_cliente-nombre
            iv_km_recorridos = ls_cliente-km_recorridos
          ) INTO TABLE lt_pasajeros.

        WHEN '034'.
          " Insertamos a Carlos
          INSERT NEW zcl_pasajero_bronce_rpc(
            iv_id                    = ls_cliente-id " <- Corregido de lt_ a ls_
            iv_nombre                = ls_cliente-nombre " <- Corregido de lt_ a ls_
            iv_km_recorridos = ls_cliente-km_recorridos " <- Corregido
          ) INTO TABLE lt_pasajeros.

        WHEN OTHERS.
          " Insertamos a María
          INSERT NEW zcl_pasajero_vip_rpc(
            iv_id                    = ls_cliente-id " <- Corregido de lt_ a ls_
            iv_nombre                = ls_cliente-nombre " <- Corregido de lt_ a ls_
            iv_km_recorridos = ls_cliente-km_recorridos " <- Corregido
          ) INTO TABLE lt_pasajeros.
      ENDCASE.

    ENDLOOP.

    "Vuelos disponibles
    DATA(lt_vuelos_disponibles) = lo_vuelos->obtener_vuelos_disponibles(  ).
    out->write( |VUELOS DISPONIBLES | ).
    out->write( lt_vuelos_disponibles ).

    "Asignación de vuelo aleatorio
    DATA(lv_registros) = lines( lt_vuelos_disponibles ).
    DATA(lo_rand) = cl_abap_random_int=>create(
                    seed = cl_abap_random=>seed( )
                    min  = 1
                    max  = lv_registros ).

    DATA(lv_indice_azar) = lo_rand->get_next( ).

    DATA(lv_vuelo_id) = lt_vuelos_disponibles[ lv_indice_azar ]-connection_id.

    "Búsqueda de precios
    DATA(lv_precio) = lo_vuelos->obtener_precios_base( it_vuelos = lt_vuelos_disponibles
    iv_connection = lv_vuelo_id ).

    DATA(lv_vuelo_obtenido) = lo_vuelos->obtener_vuelo( it_vuelos = lt_vuelos_disponibles
    iv_connection = lv_vuelo_id ).

    out->write( | | ).
    out->write( |VUELO SELECCIONADO| ).
    out->write( lv_vuelo_obtenido ).

    out->write( | | ).
    out->write( |PRECIOS FINALES | ).

    "Cálculo de descuento
    LOOP AT lt_pasajeros INTO DATA(lo_pasajeros).

      DATA(lv_desc) = lo_pasajeros->calcular_descuento( ).

      out->write( |Pasajero: { lo_pasajeros->mv_nombre } - Descuento obtenido: { lv_desc DECIMALS = 0 }%| ).
      IF lv_desc = 0.
        out->write( |Precio final: { lv_precio } | ).
      ELSE.
        lv_desc = lv_desc / 100 * lv_precio.
        out->write( |Precio final: { lv_desc DECIMALS = 2 } USD| ).
      ENDIF.

    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
