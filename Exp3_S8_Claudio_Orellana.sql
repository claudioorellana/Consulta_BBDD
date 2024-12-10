--CASO 1:
--PASOS DEL 1 AL 5 CON USUARIO ADMIN DE LA BD


-- 1. Crear usuarios
CREATE USER PRY2205_USER1 IDENTIFIED BY Clave1234567
QUOTA UNLIMITED ON USERS;

CREATE USER PRY2205_USER2 IDENTIFIED BY Clave1234567
QUOTA UNLIMITED ON USERS;

-- 2. Crear roles
CREATE ROLE PRY2205_ROL_D;
CREATE ROLE PRY2205_ROL_P;

-- 3. Asignar privilegios básicos a los usuarios
-- Privilegios del sistema para PRY2205_USER1
GRANT CREATE SESSION TO PRY2205_USER1;
GRANT CREATE ANY TABLE TO PRY2205_USER1;
GRANT CREATE ANY VIEW TO PRY2205_USER1;
GRANT CREATE ANY INDEX TO PRY2205_USER1;
GRANT CREATE PUBLIC SYNONYM TO PRY2205_USER1;

-- Privilegios para PRY2205_USER2
GRANT CREATE SESSION TO PRY2205_USER2;
GRANT CREATE VIEW TO PRY2205_USER2;

-- 4. Asignar privilegios para crear procedimientos
GRANT CREATE PROCEDURE TO PRY2205_ROL_P;

-- 5. Asignar roles a usuarios
GRANT PRY2205_ROL_D TO PRY2205_USER2;
GRANT PRY2205_ROL_P TO PRY2205_USER1;

-- NOTA: En este punto, necesitamos ejecutar el script de creación de tablas 
-- conectados como PRY2205_USER1


--PASOS DEL 6 AL 9 CONECTADOS COMO PRY2205_USER1

-- 6. Después de crear las tablas, conectados como PRY2205_USER1:
-- Otorgar permisos sobre las tablas al rol
GRANT SELECT ON MEDICO TO PRY2205_ROL_D;
GRANT SELECT ON CARGO TO PRY2205_ROL_D;

-- 7. Crear sinónimos para PAGOS y PACIENTE
CREATE PUBLIC SYNONYM PAG FOR PAGOS;
CREATE PUBLIC SYNONYM PAC FOR PACIENTE;

-- 8. Otorgar permisos sobre sinónimos
GRANT SELECT ON PAG TO PRY2205_USER2;
GRANT SELECT ON PAC TO PRY2205_USER2;

--9. INSERTAR DATOS EN TABLAS CON SCRIPT DE INSERCIÓN


--------------------------------------------------------------------------------------------


--CASO 2:


CREATE OR REPLACE VIEW PRY2205_USER2.V_RECALCULO_PAGOS AS
SELECT 
    p.pac_run AS "PAC_RUN",
    p.dv_run AS "DV_RUN",
    s.descripcion AS "SIST_SALUD",
    p.apaterno || ' ' || p.pnombre AS "NOMBRE_PCIENTE",
    TO_CHAR(bc.costo, '99999') AS "COSTO",
    CASE 
        WHEN TO_NUMBER(SUBSTR(bc.hr_consulta, 1, 2)) >= 17 
        AND TO_NUMBER(SUBSTR(bc.hr_consulta, 4, 2)) >= 15 THEN
            CASE
                WHEN bc.costo BETWEEN 15000 AND 25000 THEN 
                    TO_CHAR(ROUND(bc.costo * 1.15), '99999')
                WHEN bc.costo > 25000 THEN 
                    TO_CHAR(ROUND(bc.costo * 1.20), '99999')
                ELSE TO_CHAR(bc.costo, '99999')
            END
        ELSE TO_CHAR(bc.costo, '99999')
    END AS "MONTO_A_CANCELAR",
    TRUNC(MONTHS_BETWEEN(SYSDATE, p.fecha_nacimiento)/12) AS "EDAD"
FROM 
    PAC p
    INNER JOIN BONO_CONSULTA bc ON p.pac_run = bc.pac_run
    INNER JOIN SALUD s ON p.sal_id = s.sal_id
    INNER JOIN SISTEMA_SALUD ss ON s.tipo_sal_id = ss.tipo_sal_id
ORDER BY 
    p.pac_run,
    CASE 
        WHEN TO_NUMBER(SUBSTR(bc.hr_consulta, 1, 2)) >= 17 
        AND TO_NUMBER(SUBSTR(bc.hr_consulta, 4, 2)) >= 15 THEN
            CASE
                WHEN bc.costo BETWEEN 15000 AND 25000 THEN 
                    ROUND(bc.costo * 1.15)
                WHEN bc.costo > 25000 THEN 
                    ROUND(bc.costo * 1.20)
                ELSE bc.costo
            END
        ELSE bc.costo
    END;

-----------------------------------------------------------------------------------------------------------------------------

--CASO 3.1


-- Conectado como PRY2205_USER1
CREATE OR REPLACE VIEW VISTA_AUM_MEDICO_X_CARGO AS
SELECT 
    REPLACE(SUBSTR(TO_CHAR(m.rut_med, '00,000,000'), 2), ',', '.') || '-' || m.dv_run AS "RUT_MEDICO",
    c.nombre AS "CARGO",
    m.sueldo_base AS "SUELDO_BASE",
    '$' || REPLACE(TO_CHAR(
        CASE 
            WHEN LOWER(c.nombre) LIKE '%atención%' THEN 
                ROUND(m.sueldo_base * 1.15)
            ELSE m.sueldo_base
        END, 
        'FM9,999,999'
    ), ',', '.') AS "SUELDO_AUMENTADO"
FROM 
    MEDICO m
    INNER JOIN CARGO c ON m.car_id = c.car_id
WHERE 
    EXISTS (
        SELECT 1 
        FROM BONO_CONSULTA bc 
        WHERE bc.rut_med = m.rut_med
    )
ORDER BY 
    CASE 
        WHEN LOWER(c.nombre) LIKE '%atención%' THEN 
            ROUND(m.sueldo_base * 1.15)
        ELSE m.sueldo_base
    END;

----------------------------------------------------------------------------------------------------------------------------------------

--CASO 3.2


CREATE OR REPLACE VIEW VISTA_AUM_MEDICO_X_CARGO_2 AS
SELECT 
    REPLACE(SUBSTR(TO_CHAR(m.rut_med, '00,000,000'), 2), ',', '.') || '-' || m.dv_run AS "RUT_MEDICO",
    c.nombre AS "CARGO",
    m.sueldo_base AS "SUELDO_BASE",
    '$' || TO_CHAR(
        CASE 
            WHEN LOWER(c.nombre) LIKE '%atención%' THEN 
                ROUND(m.sueldo_base * 1.15)
            ELSE m.sueldo_base
        END, 
        'FM9,999,999'
    ) AS "SUELDO_AUMENTADO"
FROM 
    MEDICO m
    INNER JOIN CARGO c ON m.car_id = c.car_id
WHERE 
    m.car_id = 400
    AND m.sueldo_base < 1500000
    AND EXISTS (
        SELECT 1 
        FROM BONO_CONSULTA bc 
        WHERE bc.rut_med = m.rut_med
    )
ORDER BY 
    m.rut_med;










