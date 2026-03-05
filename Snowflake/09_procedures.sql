USE DATABASE OLIST_DB_BRONZE;
USE SCHEMA INGEST;

CREATE OR REPLACE PROCEDURE load_orders_raw()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_errors INTEGER;
    v_rows_loaded INTEGER;
BEGIN

    -- 1️ VALIDACIÓN
    COPY INTO ORDERS_RAW
    FROM @OLIST_RAW_STAGE/orders/olist_orders_dataset.csv
    FILE_FORMAT = FF_COMMA
    VALIDATION_MODE = RETURN_ERRORS;

    SELECT COUNT(*)
    INTO v_errors
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

    IF (v_errors > 0) THEN
        RETURN 'ERROR: Se encontraron errores en validación. Carga abortada.';
    END IF;

    -- 2️ CARGA REAL
    COPY INTO ORDERS_RAW
    FROM @OLIST_RAW_STAGE/orders/olist_orders_dataset.csv
    FILE_FORMAT = FF_COMMA;

    
    SELECT SUM($4)
    INTO v_rows_loaded
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

    RETURN 'Carga completada. Filas cargadas: ' || v_rows_loaded;

END;
$$;


CALL load_orders_raw();