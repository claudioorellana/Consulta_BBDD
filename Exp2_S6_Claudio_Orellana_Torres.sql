--CASO 1:Para evitar la pérdida de la información obtenida, debes crear la tabla RECAUDACION_BONOS_MEDICOS
--para almacenar los datos calculados en el formato adecuado, con el RUT completo del médico, el primer nombre 
--y ambos apellidos concatenados, el total recaudado y la unidad médica de atención. Ordena la información 
--según el total recaudado de menor a mayor.


CREATE TABLE RECAUDACION_BONOS_MEDICOS AS
        SELECT
            m.rut_med || '-' || m.dv_run AS RUT_MEDICO,
            m.pnombre || ' ' || m.apaterno || ' ' || m.amaterno AS NOMBRE_MEDICO,
            '$ ' || NVL(SUM(p.monto_consulta),0) AS TOTAL_RECAUDADO,
            u.nombre AS U_MEDICA_ATENCION
        FROM
                 medico m
            INNER JOIN unidad_consulta u ON m.uni_id = u.uni_id
            LEFT JOIN bono_consulta   b ON m.rut_med = b.rut_med
            LEFT JOIN pagos           p ON b.id_bono = p.id_bono
                                 AND to_char(TO_DATE(p.fecha_pago, 'DD/MM/YY'), 'YY') = '23'
        WHERE
            m.CAR_ID NOT IN (100, 500, 600)
        GROUP BY
            m.rut_med,
            m.dv_run,
            m.pnombre,
            m.apaterno,
            m.amaterno,
            u.nombre
        ORDER BY
            TO_NUMBER(REPLACE(TOTAL_RECAUDADO, '$ ', ''))
            ASC;
            

COMMIT; --confirmación de creación de la tabla

select * from RECAUDACION_BONOS_MEDICOS; --mostrar datos de la nueva tabla creada





--CASO 2: Informe de perdidas del sistema


SELECT
    e.nombre AS ESPECIALIDAD_MEDICA,
    COUNT(*) AS CANTIDAD_BONOS,
    '$ ' || SUM(b.costo) AS MONTO_PERDIDA,
    MIN(b.fecha_bono) AS FECHA_BONO,
    CASE
        WHEN to_char(TO_DATE(b.fecha_bono, 'DD/MM/YY'),'YY') >= '23' 
        THEN
            'COBRABLE'
        ELSE
            'INCOBRABLE'
    END AS ESTADO_DE_COBRO
FROM
         especialidad_medica e
    INNER JOIN (
        SELECT
            id_bono,
            esp_id,
            costo,
            fecha_bono
        FROM
            bono_consulta
        MINUS
        SELECT
            b.id_bono,
            b.esp_id,
            b.costo,
            b.fecha_bono
        FROM
            bono_consulta b
            INNER JOIN pagos p ON b.id_bono = p.id_bono
    ) b ON e.esp_id = b.esp_id
GROUP BY
    e.nombre,
    CASE
        WHEN to_char(TO_DATE(b.fecha_bono, 'DD/MM/YY'),'YY') >= '23' 
        THEN
            'COBRABLE'
        ELSE
            'INCOBRABLE'
    END
ORDER BY
    cantidad_bonos DESC,
    TO_NUMBER(replace(replace(monto_perdida, '$ ', ''),',','')) 
    DESC;




--CASO 3: CORREGIR DATOS E INSERTAR EN LA TABLA CANT_BONOS_PACIENTES_ANNIO

--SE CONSIDERA LOS DATOS QUE YA ESTABAN EN ESTA TABLA SON ERRONEOS POR LO TANTO
--ELIMINAREMOS LOS REGISTROS ANTES DE POBLAR
DELETE FROM CANT_BONOS_PACIENTES_ANNIO 
COMMIT;


--SE GENERA LA CONSULTA PARA INSERTAR LOS DATOS EN LA TABLA SEGÚN SOLICITUD
INSERT INTO CANT_BONOS_PACIENTES_ANNIO
SELECT
    '2024' AS ANNIO_CALCULO,
    p.pac_run,
    p.dv_run,
    TRUNC((sysdate - p.fecha_nacimiento) / 365) AS EDAD,
    COUNT(DISTINCT b.id_bono) AS CANTIDAD_BONOS,
    NVL(SUM(pg.monto_a_cancelar),0) AS MONTO_TOTAL_BONOS,
    CASE
        WHEN s2.tipo_sal_id = 'F'  THEN
            'FONASA'
        WHEN s2.tipo_sal_id = 'P'  THEN
            'PARTICULAR'
        WHEN s2.tipo_sal_id = 'FA' THEN
            'FUERZAS ARMADAS'
    END  AS SISTEMA_SALUD
FROM
    paciente p
    INNER JOIN salud s ON p.sal_id = s.sal_id
    INNER JOIN sistema_salud s2 ON s.tipo_sal_id = s2.tipo_sal_id
    LEFT JOIN bono_consulta b ON p.pac_run = b.pac_run AND TO_CHAR(TO_DATE(b.fecha_bono, 'DD/MM/YY'),'YY') = '24'
    LEFT JOIN pagos pg ON b.id_bono = pg.id_bono
WHERE
    s2.tipo_sal_id IN ( 'F', 'P', 'FA' )
GROUP BY
    p.pac_run,
    p.dv_run,
    p.fecha_nacimiento,
    s2.tipo_sal_id
HAVING
    NVL(COUNT(DISTINCT b.id_bono),0) <= (SELECT ROUND(AVG(cantidad_bonos))
        FROM
            ( SELECT pac_run, COUNT(id_bono) AS CANTIDAD_BONOS
                FROM bono_consulta
                WHERE
                    TO_CHAR(TO_DATE(fecha_bono, 'DD/MM/YY'),'YY') = '23'
                GROUP BY
                    pac_run
            )
    )
ORDER BY
    CANTIDAD_BONOS ASC,
    EDAD DESC;

COMMIT;


--SE CONSULTA LA TABLA CON LOS VALORES CORREGIDOS
SELECT * FROM CANT_BONOS_PACIENTES_ANNIO
























