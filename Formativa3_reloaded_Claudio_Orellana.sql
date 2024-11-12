--1.- Obtener una lista de las ventas realizadas en los últimos tres meses, 
--mostrando el nombre del cliente, el nombre del producto, la cantidad vendida 
--y la fecha de la venta.

--También es necesario agregar 2 campos que permita hacer seguimiento a la garantía 
--de cada producto, el primer campo es determinar la fecha final de garantía a partir 
--de la fecha de venta, para productos con Categoría Monitores, Portátiles, Proyectores, 
--Impresoras tienen una garantía de 90 días, Almacenamiento y Energía tienen una 
--garantía de 180 días, toda otra categoría solo tiene 30 días de garantía. 
--A partir de esta fecha final de garantía incorporar el campo Garantía vigente, 
--el cual contendrá "SI" si tiene garantía vigente a la fecha de hoy y "NO" 
--si no tiene vigente su garantía.

SELECT
    c.nombre||' '||c.apellido AS CLIENTE,
    p.nombre_producto,
    p.categoria,
    v.cantidad    AS CANTIDAD_VENDIDA,
    v.fecha_venta,
    CASE
        WHEN p.categoria IN ( 'Monitores', 'Portátiles', 'Proyectores', 'Impresoras' ) THEN
            v.fecha_venta + 90
        WHEN p.categoria IN ( 'Almacenamiento', 'Energía' ) THEN
            v.fecha_venta + 180
        ELSE
            v.fecha_venta + 30
    END           AS FIN_GARANTIA,
    CASE
        WHEN (
            CASE
                WHEN p.categoria IN ( 'Monitores', 'Portátiles', 'Proyectores', 'Impresoras' ) THEN
                    v.fecha_venta + 90
                WHEN p.categoria IN ( 'Almacenamiento', 'Energía' ) THEN
                    v.fecha_venta + 180
                ELSE
                    v.fecha_venta + 30
            END
        ) >= trunc(sysdate) THEN
            'SI'
        ELSE
            'NO'
    END           AS GARANTIA_VIGENTE
FROM
         ventas v
    INNER JOIN clientes  c ON v.customer_id = c.customer_id
    INNER JOIN productos p ON v.product_id = p.product_id
WHERE
    v.fecha_venta >= add_months(trunc(sysdate),
                                - 3)
ORDER BY
    v.fecha_venta DESC;


---------------------------------------------------------------------------------------

--2.- Obtener el nombre completo (nombre y apellido juntos en Mayúscula) de cada miembro del personal de ventas, 
--Incluir a todo el personal, incluso aquellos que no han realizado ventas.
--Se debe incorporar un campo Zona al que pertenece cada empleado, él cual se debe inferir a partir del numero de teléfono, 
--si los primeros 3 dígitos corresponden a 123 se clasifica como Zona Alpha, si primeros 3 dígitos corresponden a 456 
--se clasifica como Zona Beta y si primeros 3 dígitos corresponden a 789 se clasifica como Zona Gamma, estos campos se deben agrupar 
--para poder obtener el total de ventas que ha realizado.
--Solo debe desplegar al personal que ha logrado una venta mayor o igual a 1000.

SELECT 
    UPPER(p.NOMBRE || ' ' || p.APELLIDO) as VENDEDOR,
    CASE 
        WHEN SUBSTR(p.TELEFONO, 1, 3) = '123' THEN 'ZONA ALPHA'
        WHEN SUBSTR(p.TELEFONO, 1, 3) = '456' THEN 'ZONA BETA'
        WHEN SUBSTR(p.TELEFONO, 1, 3) = '789' THEN 'ZONA GAMMA'
        ELSE ' '
    END as ZONA,
    COUNT(v.SALE_ID) as CANTIDAD_VENTAS,
    NVL(SUM(v.TOTAL_VENTA), 0) as TOTAL_VENTAS
FROM 
    PERSONAL_DE_VENTAS p
    LEFT JOIN VENTAS v ON p.STAFF_ID = v.STAFF_ID
GROUP BY 
    p.NOMBRE,
    p.APELLIDO,
    p.TELEFONO
HAVING 
    NVL(SUM(v.TOTAL_VENTA), 0) >= 1000
ORDER BY 
    TOTAL_VENTAS DESC;


----------------------------------------------------------------------------------------------


--3.- Listar todos los clientes y los productos que han comprado. 
--En caso de que un cliente no haya realizado compras, mostrar el cliente con "Sin compras".
--Incluir el nombre del cliente, su email, el nombre del producto y la cantidad vendida. 
--asegurar que solo se desplieguen compras con productos existentes en la base de datos.
--*Cuando hablamos de compras nos referimos la evento registrado en la tabla de Ventas.

SELECT 
    c.NOMBRE || ' ' || c.APELLIDO as CLIENTE,
    c.EMAIL,
    COALESCE(p.NOMBRE_PRODUCTO, 'SIN COMPRAS') as "NOMBRE PRODUCTO",
    NVL(v.CANTIDAD, 0) as "CANTIDAD VENDIDA"
FROM 
    CLIENTES c
    LEFT JOIN VENTAS v ON c.CUSTOMER_ID = v.CUSTOMER_ID
    LEFT JOIN PRODUCTOS p ON v.PRODUCT_ID = p.PRODUCT_ID
ORDER BY 
    c.NOMBRE,
    c.APELLIDO,
    p.NOMBRE_PRODUCTO;

------------------------------------------------------------------------------------------------------------------



--4.- La empresa desea conocer una lista de todos los productos junto con los nombres 
--de todos los clientes, sin importar si estos han comprado el producto o no.
--Esto permitirá identificar clientes potenciales para cada producto.


SELECT 
    p.NOMBRE_PRODUCTO, 
    c.NOMBRE || ' ' || c.APELLIDO AS NOMBRE_CLIENTE
FROM 
    productos p
CROSS JOIN 
    clientes c
ORDER BY 
    p.NOMBRE_PRODUCTO, c.NOMBRE;


