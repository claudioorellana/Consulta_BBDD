-- Creación de la tabla Clientes
CREATE TABLE customers (
    customer_id    NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre         VARCHAR2(50) NOT NULL,
    apellido       VARCHAR2(50) NOT NULL,
    fecha_registro DATE,
    email          VARCHAR2(100) UNIQUE,
    telefono       VARCHAR2(12)
);

-- Creación de la tabla Productos
CREATE TABLE products (
    product_id      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    categoria       VARCHAR2(50),
    precio          NUMBER NOT NULL CHECK ( precio > 0 ),
    stock           NUMBER DEFAULT 0 CHECK ( stock >= 0 )
);

-- Creación de la tabla Personal de Ventas
CREATE TABLE sales_staff (
    staff_id       NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre_staff   VARCHAR2(50) NOT NULL,
    apellido_staff VARCHAR2(50) NOT NULL,
    email_staff    VARCHAR2(100) UNIQUE,
    telefono_staff VARCHAR2(20)
);

-- Creación de la tabla Ventas
CREATE TABLE sales (
    sale_id     NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    customer_id NUMBER,
    product_id  NUMBER,
    staff_id    NUMBER,
    cantidad    NUMBER NOT NULL CHECK ( cantidad > 0 ),
    fecha_venta DATE,
    total_venta NUMBER,
    CONSTRAINT fk_customer FOREIGN KEY ( customer_id )
        REFERENCES customers ( customer_id ),
    CONSTRAINT fk_product FOREIGN KEY ( product_id )
        REFERENCES products ( product_id ),
    CONSTRAINT fk_staff FOREIGN KEY ( staff_id )
        REFERENCES sales_staff ( staff_id )
);



-----------------------------------------------------------------------------------------------------------------------------

--INSERTA DATOS

-- Inserción de datos en la tabla customers
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Claudio', 'Orellana', TO_DATE('2018-12-08', 'YYYY-MM-DD'), 'claudio.orellana@mail.com', '+56985975927');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Manuel', 'Diaz', TO_DATE('2020-10-23', 'YYYY-MM-DD'), 'manueldiaz@hotmail.com', '+56994852678');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Marta', 'Torres', TO_DATE('2022-04-09', 'YYYY-MM-DD'), 'marta.torres@gmail.com', '+56984646293');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Maria Paz', 'Llanten', TO_DATE('2021-01-01', 'YYYY-MM-DD'), 'paz.llanten@mail.com', '+56912345698');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Leopoldo', 'Carreras', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'leo.carreras@hotmail.com', '+56998765412');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Rodrigo', 'Rivera', TO_DATE('2024-10-03', 'YYYY-MM-DD'), 'rodrigo.rivera@gmail.com', '+56912345678');
INSERT INTO customers (nombre, apellido, fecha_registro, email, telefono)
VALUES ('Jorge', 'Cerda', TO_DATE('2024-10-21', 'YYYY-MM-DD'), 'jorgecerda@mail.com', '+56913467985');


-- Inserción de datos en la tabla products
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('iPhone 15', 'Smartphone', 1200000, 14);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Samsung Galaxy S24', 'Smartphone', 950000, 9);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Thinkpad T16', 'Notebook', 1600000, 2);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('HP pavilion x360', 'notebook', 1150000, 0);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Monitor viewsonic 55 pulgadas', 'Monitor', 600000, 21);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('HP Calculadora cientifica', 'Calculadora', 80000, 15);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Asistente virtual Alexa', 'Domotica', 130000, 7);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Radio digital Toshiba', 'Audio', 95990, 12);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Parlante HI-FI Aiwa', 'Audio', 135000, 18);
INSERT INTO products (nombre_producto, categoria, precio, stock)
VALUES ('Lenovo Yoga', 'Audio', 1100000, 11);


-- Inserción de datos en la tabla sales__Staff
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Salvador', 'Castro', 'salvador.castro@tecno.cl', '+56975899555');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Andres', 'Borquez', 'andres.borquez@tecno.cl', '+56948899123');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Yamila', 'Rojo', 'yamila.rojo@tecno.cl', '+56912345678');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Paola', 'Gonzalez', 'paola.gonzalez@tecno.cl', '+56998765432');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Claudia', 'Rivera', 'claudia.rivera@tecno.cl', '+56975383777');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Carlos', 'Gaona', 'carlos.gaona@tecno.cl', '+56979461325');
INSERT INTO sales_staff (nombre_staff, apellido_staff, email_staff, telefono_staff)
VALUES ('Antonio', 'Gonzalez', 'antonio.gonzalez@tecno.cl', '+56987251971');


-- Inserción de datos en la tabla sales
INSERT INTO sales (customer_id, product_id, staff_id, cantidad, fecha_venta, total_venta) VALUES 
    (1, 1, 5, 2, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 2400000);
INSERT INTO sales (customer_id, product_id, staff_id, cantidad, fecha_venta, total_venta) VALUES 
    (2, 2, 2, 1, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 950000);
INSERT INTO sales (customer_id, product_id, staff_id, cantidad, fecha_venta, total_venta) VALUES 
    (3, 3, 3, 3, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 4800000);
INSERT INTO sales (customer_id, product_id, staff_id, cantidad, fecha_venta, total_venta) VALUES 
    (4, 4, 4, 1, TO_DATE('2024-03-15', 'YYYY-MM-DD'), 1000000);
INSERT INTO sales (customer_id, product_id, staff_id, cantidad, fecha_venta, total_venta) VALUES 
    (5, 5, 5, 4, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 2400000);

------------------------------------------------------------------------------------------------------------------


--DESAFIO 1: Obtener la lista de clientes registrados en el último mes, 
--mostrando su nombre completo y fecha de registro. Ordenar la lista por fecha de registro en orden descendente.

SELECT
    concat(nombre, ' ')
    || apellido AS nombre_completo,
    fecha_registro
FROM
    customers
WHERE
        EXTRACT(YEAR FROM fecha_registro) = EXTRACT(YEAR FROM sysdate)
    AND EXTRACT(MONTH FROM fecha_registro) = EXTRACT(MONTH FROM sysdate)
ORDER BY
    2 DESC;




--DESAFIO 2: Calcular el incremento del 15% del precio de todos los productos cuyo nombre termine en A 
--y que tengan más de 10 unidades en stock. Considera el resultado del incremento con 1 decimal. 
--Ordenar el listado por el incremento de forma ascendente.

SELECT
    round(precio * 1.15, 1) AS "INCREMENTO",
    nombre_producto         AS "PRODUCTO",
    stock
FROM
    products
WHERE
    nombre_producto LIKE '%a'
    AND stock > 10
ORDER BY
    1 ASC;





--DESAFIO 3: Mostrar la lista del personal de ventas registrado en la base de datos, 
--mostrando su nombre completo, correo electrónico y creando una contraseña por defecto que cumpla los siguientes requisitos:
--4 primeras letras del nombre 
--Cantidad de caracteres de su email
--3 últimas letras del apellido 
--Ordenar la lista por apellido de forma descendente y por nombre de forma ascendente.


SELECT
    concat(nombre_staff, ' ')
    || apellido_staff              AS nombre_completo,
    email_staff                    AS "Correo Electrónico",
    substr(nombre_staff, 1, 4)
    || length(email_staff)
    || substr(apellido_staff, - 3) AS "Contraseña"
FROM
    sales_staff
ORDER BY
    apellido_staff DESC,
    nombre_staff ASC;


