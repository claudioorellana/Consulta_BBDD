--CASO 1:

-- Lista el nombre de cada producto agrupado por categoría. Ordena los resultados por precio de mayor a menor.

SELECT
    nombre,
    categoria,
    precio
FROM
    productos
ORDER BY
    categoria,
    precio DESC;


-- Calcula el promedio de ventas mensuales (en cantidad de productos) y muestra el mes y año con mayores ventas.

SELECT 
    TO_CHAR(fecha, 'MM-YYYY') as MES_AÑO,
    ROUND(AVG(cantidad), 2) as "PROMEDIO VENTA MENSUAL",
    COUNT(*) as "VENTAS POR MES",
    SUM(cantidad) as "TOTAL PRODUCTOS VENDIDOS POR MES",
    
    CASE 
        WHEN SUM(cantidad) = (
            SELECT MAX(suma_cantidad)
            FROM (
                SELECT SUM(cantidad) as suma_cantidad
                FROM ventas
                GROUP BY TO_CHAR(fecha, 'MM-YYYY')
            )
        ) THEN 'MES CON MAYOR VENTA'
        ELSE ' '
    END as "MAYOR VENTA POR MES"
    
FROM ventas
GROUP BY TO_CHAR(fecha, 'MM-YYYY')
ORDER BY TO_DATE(TO_CHAR(fecha, 'MM-YYYY'), 'MM-YYYY');




--Encuentra el ID del cliente que ha gastado más dinero en compras durante el último año. 
--Asegúrate de considerar clientes que se registraron hace menos de un año.

SELECT
    c.cliente_id,
    c.nombre,
    c.fecha_registro,
    SUM(v.cantidad * p.precio) AS total_gastado
FROM
         clientes c
    INNER JOIN ventas    v ON c.cliente_id = v.cliente_id
    INNER JOIN productos p ON v.producto_id = p.producto_id
WHERE
        c.fecha_registro >= add_months(sysdate, - 12)
    AND v.fecha >= add_months(sysdate, - 12)
GROUP BY
    c.cliente_id,
    c.nombre,
    c.fecha_registro
HAVING
    SUM(v.cantidad * p.precio) = (
        SELECT
            MAX(SUM(v2.cantidad * p2.precio))
        FROM
                 clientes c2
            INNER JOIN ventas    v2 ON c2.cliente_id = v2.cliente_id
            INNER JOIN productos p2 ON v2.producto_id = p2.producto_id
        WHERE
                c2.fecha_registro >= add_months(sysdate, - 12)
            AND v2.fecha >= add_months(sysdate, - 12)
        GROUP BY
            c2.cliente_id
    )
ORDER BY
    total_gastado DESC;

--CASO 2:

--Determina el salario promedio, el salario máximo y el salario mínimo por departamento.

SELECT
    departamento,
    round(AVG(salario),
          2)     AS salario_promedio,
    MAX(salario) AS salario_maximo,
    MIN(salario) AS salario_minimo
FROM
    empleados
GROUP BY
    departamento
ORDER BY
    departamento;



--Utilizando funciones de grupo, encuentra el salario más alto en cada departamento.

SELECT
    departamento,
    MAX(salario) AS salario_maximo
FROM
    empleados
GROUP BY
    departamento
ORDER BY
    salario_maximo DESC;





--Calcula la antigüedad en años de cada empleado y muestra aquellos con más de 10 años en la empresa.

SELECT
    empleado_id,
    nombre,
    departamento,
    fecha_contratacion,
    trunc(months_between(sysdate, fecha_contratacion) / 12) AS antiguedad_años
FROM
    empleados
WHERE
    ( months_between(sysdate, fecha_contratacion) / 12 ) > 10
ORDER BY
    antiguedad_años DESC;






