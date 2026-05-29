CLASS zcl_gestion_suscrip_rpc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

    DATA mt_suscripcion TYPE STANDARD TABLE OF zdb_suscrip_rpc.

    "Creación de tipo de tabla
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    TYPES tt_suscripcion TYPE TABLE OF zdb_suscrip_rpc.
    METHODS constructor IMPORTING it_suscripcion TYPE tt_suscripcion.
    METHODS crear_suscripcion IMPORTING iv_usuario            TYPE uname
                                        iv_tipo_plan          TYPE zde_sub_tipo_rpc
                                        iv_precio             TYPE zdb_suscrip_rpc-precio
                              RETURNING VALUE(rv_id_suscripcion) TYPE zde_sub_id_rpc.
    METHODS modificar_estado IMPORTING iv_id_suscripcion TYPE zde_sub_id_rpc
                                       iv_nuevo_estado   TYPE zde_sub_estado_rpc.
    "Las tablas las exportamos a menos que tt forme parte del dic de datos
    "Así que usaré EXPORTING y no RETURNING VALUE
    METHODS obtener_activas EXPORTING et_suscripciones_activas TYPE tt_suscripcion.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gestion_suscrip_rpc IMPLEMENTATION.



  METHOD constructor.
    "Al ser dos tablas internas en memoria se puede almacernar con un igual
    mt_suscripcion = it_suscripcion.
  ENDMETHOD.

  METHOD crear_suscripcion.
    DATA ls_suscripcion TYPE zdb_suscrip_rpc.
    SELECT MAX( id_suscrip ) FROM zdb_suscrip_rpc INTO @DATA(lv_max_id).

    "Combrobación de último ID
    IF lv_max_id IS INITIAL OR lv_max_id = 0.
      lv_max_id = 1.
    ELSE.
      lv_max_id += 1.
    ENDIF.

    "Fecha de alta
    ls_suscripcion-fecha_alta = cl_abap_context_info=>get_system_date( ).

    "Estado de la suscripcion
    ls_suscripcion-estado = 'A'.


  ENDMETHOD.

  METHOD modificar_estado.
    "Comprobación de existencia del ID

    LOOP AT mt_suscripcion INTO DATA(ls_suscripcion).
      IF iv_id_suscripcion EQ ls_suscripcion-id_suscrip.
        "En caso de existir, cambio de estado
        IF ls_suscripcion-estado EQ 'A'.
          ls_suscripcion-estado = 'I'.
        ELSE.
          ls_suscripcion-estado = 'A'.
        ENDIF.

        MODIFY mt_suscripcion FROM ls_suscripcion.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD obtener_activas.
    LOOP AT mt_suscripcion INTO DATA(ls_suscripcion).
      IF ls_suscripcion-estado EQ 'A'.
        APPEND ls_suscripcion TO et_suscripciones_activas.
      ENDIF.

endloop.

  ENDMETHOD.

ENDCLASS.
