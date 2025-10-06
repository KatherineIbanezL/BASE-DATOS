-- ELIMINACION DE TABLAS EN ORDEN CON CASCADE
DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS;
DROP TABLE VENTA CASCADE CONSTRAINTS;
DROP TABLE VENDEDOR CASCADE CONSTRAINTS;
DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;
DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS;
DROP TABLE PRODUCTO CASCADE CONSTRAINTS;
DROP TABLE PROVEEDOR CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE REPORTE CASCADE CONSTRAINTS;
DROP TABLE REPORTE2 CASCADE CONSTRAINTS;

-- LIMPIAR SECUENCIAS
DROP SEQUENCE seq_salud;
DROP SEQUENCE seq_empleado;

-- CASO 1 IMPLEMENTACION DEL MODELO

--CREACION TABLA REGION
CREATE TABLE REGION
(
    id_region NUMBER(4),
    nombre VARCHAR2(25) NOT NULL    
);

--CREACION TABLA COMUNA
CREATE TABLE COMUNA
(
    id_comuna NUMBER(4),
    nombre VARCHAR2(100) NOT NULL,
    cod_region NUMBER(4) NOT NULL
);

-- CREACION TABLA PROVEEDOR
CREATE TABLE PROVEEDOR
(
    id_proveedor NUMBER(5),
    nombre VARCHAR2(150) NOT NULL,
    rut VARCHAR2(10) NOT NULL,
    telefono VARCHAR2(10) NOT NULL,
    email VARCHAR2(200) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    cod_comuna NUMBER(4) NOT NULL
);

-- CREACION TABLA MARCA
CREATE TABLE MARCA
(
    id_marca NUMBER(3),
    nombre VARCHAR2(25) NOT NULL
);

-- CREACION TABLA CATEGORIA
CREATE TABLE CATEGORIA
(
    id_categoria NUMBER(3),
    nombre VARCHAR2(25) NOT NULL
);

-- CREACION TABLA PRODUCTO
CREATE TABLE PRODUCTO
(
    id_producto NUMBER(4),
    nombre VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    origen_nacional CHAR(1) DEFAULT 'S',
    stock_minimo NUMBER(3) NOT NULL,
    activo CHAR(1) DEFAULT 'S',
    cod_marca NUMBER(3) NOT NULL,
    cod_categoria NUMBER(3) NOT NULL,
    cod_proveedor NUMBER(5) NOT NULL
);

-- CREACION TABLA MEDIO_PAGO
CREATE TABLE MEDIO_PAGO
(
    id_mpago NUMBER(3),
    nombre VARCHAR2(50) NOT NULL
);

-- CREACION TABLA AFP
CREATE TABLE AFP
(
    id_afp NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 6),
    nombre VARCHAR2(25) NOT NULL
);

-- CREACION TABLA SALUD
CREATE TABLE SALUD
(
    id_salud NUMBER(4),
    nombre VARCHAR2(40) NOT NULL
);

-- CREACION TABLA EMPLEADO
CREATE TABLE EMPLEADO
(
    id_empleado NUMBER(4),
    rut VARCHAR2(10) NOT NULL,
    nombre VARCHAR2(25) NOT NULL,
    apellido_p VARCHAR2 (25) NOT NULL,
    apellido_m VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER(10),
    activo CHAR(1) DEFAULT 'S',
    tipo_empleado VARCHAR2(25) NOT NULL,
    cod_empleado NUMBER(4),
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER(5) NOT NULL
);

-- CREACION TABLA VENDEDOR
CREATE TABLE VENDEDOR
(
    id_empleado NUMBER(4),
    comision_venta NUMBER(5,2) NOT NULL
);

-- CREACION TABLA ADMINISTRATIVO
CREATE TABLE ADMINISTRATIVO
(
    id_empleado NUMBER(4)
);

-- CREACION TABLA VENTA
CREATE TABLE VENTA
(
    id_venta NUMBER(4) GENERATED ALWAYS AS IDENTITY (START WITH 5050 INCREMENT BY 3),
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    cod_mpago NUMBER(3) NOT NULL,
    cod_empleado NUMBER(4) NOT NULL   
);

-- CREACION TABLA DETALLE_VENTA
CREATE TABLE DETALLE_VENTA
(   
    cod_venta NUMBER(4) NOT NULL,
    cod_producto NUMBER(4) NOT NULL,
    cantidad NUMBER(6) NOT NULL
);


-- ALTER TABLE PARA AGREGAR CLAVE PRIMARIA, CLAVE FORANEA, CHECK, UNIQUE A TABLAS CREADAS ANTERIORMENTE

-- TABLA REGION --------------------------------
-- PK ID TABLA REGION
ALTER TABLE REGION
ADD CONSTRAINT PK_REGION PRIMARY KEY (id_Region);

-- UN NOMBRE UNICO EN TABLA REGION
ALTER TABLE REGION
ADD CONSTRAINT UN_REGION UNIQUE (nombre);

-- TABLA COMUNA --------------------------------
-- PK ID TABLA COMUNA
ALTER TABLE COMUNA
ADD CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna);

-- UN NOMBRE UNICO EN TABLA COMUNA
ALTER TABLE COMUNA
ADD CONSTRAINT UN_COMUNA UNIQUE (nombre);

-- FK ID REGION TABLA COMUNA
ALTER TABLE COMUNA
ADD CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region) REFERENCES REGION (id_region);

-- TABLA PROVEEDOR --------------------------------
-- PK ID TABLA PROVEEDOR
ALTER TABLE PROVEEDOR
ADD CONSTRAINT PK_PROVEEDOR PRIMARY KEY (id_proveedor);

-- UN PARA NOMBRE UNICO EN TABLA PROVEEDOR
ALTER TABLE PROVEEDOR
ADD CONSTRAINT UN_PROV_NOM UNIQUE (nombre);

-- UN PARA RUT UNICO EN TABLA PROVEEDOR
ALTER TABLE PROVEEDOR
ADD CONSTRAINT UN_PROV_RUT UNIQUE (rut);

-- FK ID COMUNA TABLA PROVEEDOR
ALTER TABLE PROVEEDOR
ADD CONSTRAINT FK_PROVEEDOR_COMUNA FOREIGN KEY (cod_comuna) REFERENCES COMUNA (id_comuna);

-- CK PARA LIMITAR LARGO DE RUT EN TABLA PROVEEDOR
ALTER TABLE PROVEEDOR
ADD CONSTRAINT CK_RUTPRO_L CHECK (LENGTH(rut) BETWEEN 9 AND 10);

-- TABLA MARCA --------------------------------
-- PK ID TABLA MARCA
ALTER TABLE MARCA
ADD CONSTRAINT PK_MARCA PRIMARY KEY (id_marca);

-- TABLA CATEGORIA --------------------------------
-- PK ID TABLA CATEGORIA
ALTER TABLE CATEGORIA
ADD CONSTRAINT PK_CATEGORIA PRIMARY KEY (id_categoria);

-- TABLA PRODUCTO --------------------------------
-- PK ID TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY (id_producto);

-- FK ID MARCA TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_MARCA FOREIGN KEY (cod_marca) REFERENCES MARCA (id_marca);

-- FK ID CATEGORIA TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_CAT FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA (id_categoria);

-- FK ID PROVEEDOR TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_PROV foreign key (cod_proveedor) REFERENCES PROVEEDOR (id_proveedor);

-- CK PARA VALIDAR PRODUCTO ACTIVO EN TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT CK_ACTIVO CHECK (activo IN ('S', 'N'));

-- CK PARA VALIDAR SI ES PRODUCTO DE ORIGEN NACIONAL EN TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT CK_ORIGEN_NAC CHECK (origen_nacional IN ('S', 'N'));

-- TABLA MEDIO_PAGO --------------------------------
-- PK ID TABLA MEDIO_PAGO
ALTER TABLE MEDIO_PAGO
ADD CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY (id_mpago);

-- TABLA AFP --------------------------------
-- PK ID TABLA AFP
ALTER TABLE AFP
ADD CONSTRAINT PK_AFP PRIMARY KEY (id_afp);

-- TABLA SALUD --------------------------------
-- PK ID TABLA SALUD
ALTER TABLE SALUD
ADD CONSTRAINT PK_SALUD PRIMARY KEY (id_salud);

-- TABLA EMPLEADO --------------------------------
-- PK ID TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY (id_empleado);

-- UN PARA QUE RUT SEA UNICO EN TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT UN_EMPLEADO_RUT UNIQUE (rut);

-- FK ID EMPLEADO EN TABLA EMPLEADO RELACION RECURSIVA
ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_EMP FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado);
    
-- FK ID SALUD TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_SALUD FOREIGN KEY (cod_salud) REFERENCES SALUD (id_salud);   

-- FK ID AFP TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_EMPLEADO_AFP FOREIGN KEY (cod_afp) REFERENCES AFP (id_afp);   

-- CK PARA LIMITAR LARGO RUT EN TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT CK_RUTEMP_L CHECK (LENGTH(rut) BETWEEN 9 AND 10);   

-- CK PARA VALIDAR SI EMPLEADO SE ENCUENTRA ACTIVO EN TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT CK_ACTIVO_EMP CHECK (activo IN ('S', 'N'));   

-- CK TIPO EMPLEADO TABLA EMPLEADO
ALTER TABLE EMPLEADO
ADD CONSTRAINT CK_TIPO_EMP CHECK (tipo_empleado IN ('ADMINISTRATIVO', 'VENDEDOR'));

-- TABLA VENDEDOR --------------------------------
-- PK ID EMPLEADO TABLA VENDEDOR
ALTER TABLE VENDEDOR
ADD CONSTRAINT PK_VENDEDOR PRIMARY KEY (id_empleado);

-- FK ID EMPLEADO TABLA VENDEDOR
ALTER TABLE VENDEDOR
ADD CONSTRAINT FK_VENDEDOR_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado);

-- TABLA ADMINISTRATIVO --------------------------------
-- PK ID EMPLEADO TABLA ADMINISTRATIVO
ALTER TABLE ADMINISTRATIVO
ADD CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (id_empleado);

-- FK ID EMPLEADO TABLA ADMINISTRATIVO
ALTER TABLE ADMINISTRATIVO
ADD CONSTRAINT FK_ADMIN_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado);

-- TABLA VENTA --------------------------------
-- PK ID TABLA VENTA
ALTER TABLE VENTA
ADD CONSTRAINT PK_VENTA PRIMARY KEY (id_venta);

-- FK ID MEDIO_PAGO TABLA VENTA
ALTER TABLE VENTA
ADD CONSTRAINT FK_VENTA_MPAGO FOREIGN KEY (cod_mpago) REFERENCES MEDIO_PAGO (id_mpago);

-- FK ID EMPLEADO TABLA VENTA
ALTER TABLE VENTA
ADD CONSTRAINT FK_VENTA_EMP FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO (id_empleado);

-- TABLA DETALLE_VENTA --------------------------------
-- PK ID COMPUESTA TABLA DETALLE_VENTA
ALTER TABLE DETALLE_VENTA
ADD CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY (cod_venta, cod_producto);

-- FK ID VENTA TABLA DETALLE_VENTA
ALTER TABLE DETALLE_VENTA
ADD CONSTRAINT FK_DETALLE_V_VENTA FOREIGN KEY (cod_venta) REFERENCES VENTA (id_venta);

-- FK ID PRODUCTO TABLA DETALLE_VENTA
ALTER TABLE DETALLE_VENTA
ADD CONSTRAINT FK_DETALLE_V_PROD FOREIGN KEY (cod_producto) REFERENCES PRODUCTO (id_producto);
    

-- CASO 2: MODIFICACION DEL MODELO

-- RESTRICCION CHECK PARA SUELDO BASE CON UN MINIMO VIGENTE EN TABLA EMPLEADO 
ALTER TABLE EMPLEADO
ADD CONSTRAINT ck_sueldo_min CHECK (sueldo_base >= 400);

-- VALIDACION CHECK PARA COMISION DE VENTA EN TABLA VENDEDOR 
ALTER TABLE VENDEDOR
ADD CONSTRAINT ck_comision CHECK (comision_venta BETWEEN 0 AND 0.25);

-- RESTRICCION CHECK PARA VALIDAR EL STOCK MINIMO EN TABLA PRODUCTO
ALTER TABLE PRODUCTO
ADD CONSTRAINT ck_stock_min CHECK (stock_minimo >= 3);

-- RESTRICCION UNIQUE EN TABLA PROVEEDOR PARA EVITAR CORREO ELECTRONICO DUPLICADO
ALTER TABLE PROVEEDOR
ADD CONSTRAINT un_proveedor_correo UNIQUE (email);

-- RESTRICCION UNIQUE EN TABLA MARCA PARA NOMBRE UNICO
ALTER TABLE MARCA
ADD CONSTRAINT UN_MARCA_NOMBRE UNIQUE (nombre);

-- RESTRICCION CHECK EN TABLA DETALLE_VENTA PARA QUE CANTIDAD SEA MAYOR A 0
ALTER TABLE DETALLE_VENTA
ADD CONSTRAINT CK_CANTIDAD CHECK (cantidad > 0);

-- CASO 3: POBLAMIENTO DEL MODELO

-- CREACION DE SECUENCIA PARA TABLA SALUD (DE 2050 CON INCREMENTO DE 10 EN 10)
CREATE SEQUENCE seq_salud
START WITH 2050 
INCREMENT BY 10;

-- CREACION DE SECUENCIA PARA TABLA EMPLEADO CON IDENTIFICACION QUE COMIENZA EN 750 Y SE INCREMENTA EN 3
CREATE SEQUENCE seq_empleado
START WITH 750
INCREMENT BY 3;

-- POBLACION DE TABLA REGION
INSERT INTO REGION (id_region, nombre) VALUES (1, 'Región Metropolitana');
INSERT INTO REGION (id_region, nombre) VALUES (2, 'Valparaiso');
INSERT INTO REGION (id_region, nombre) VALUES (3, 'Biobio');
INSERT INTO REGION (id_region, nombre) VALUES (4, 'Los Lagos');

-- POBLACION DE TABLA COMUNA
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (1, 'Santiago', 1);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (2, 'Providencia', 1);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (3, 'Valparaíso', 2);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (4, 'Viña del Mar', 2);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (5, 'Concepción', 3);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (6, 'Chiguayante', 3);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (7, 'Puerto Montt', 4);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (8, 'Osorno', 4);

-- POBLACION DE TABLA PROVEEDOR
INSERT INTO PROVEEDOR 
(id_proveedor, nombre, rut, telefono, email, direccion, cod_comuna) VALUES
(10101, 'Distribuidora Mayorista', '12345678-9', '912345678', 'contacto@mayorista.cl', 'Av. Verdel 123', 1);

INSERT INTO PROVEEDOR 
(id_proveedor, nombre, rut, telefono, email, direccion, cod_comuna) VALUES
(10102, 'Lacteos del Sur', '98765432-1', '923453456', 'ventas@lacteosur.cl', 'Calle Colun 656', 7);

INSERT INTO PROVEEDOR 
(id_proveedor, nombre, rut, telefono, email, direccion, cod_comuna) VALUES
(10103, 'Distribuidora Gomita', '37617568-5', '919283746', 'info@gomitas.cl', 'Av. Dulce 321', 5);

INSERT INTO PROVEEDOR 
(id_proveedor, nombre, rut, telefono, email, direccion, cod_comuna) VALUES
(10104, 'Bebidas Esperanza', '45678374-9', '947583967', 'contacto@esperanza.cl', 'Calle Esperanza 340', 3);

-- POBLAMIENTO DE TABLA MARCA
INSERT INTO MARCA (id_marca, nombre) VALUES (301, 'Nestlé');
INSERT INTO MARCA (id_marca, nombre) VALUES (302, 'CCU');
INSERT INTO MARCA (id_marca, nombre) VALUES (303, 'Colun');
INSERT INTO MARCA (id_marca, nombre) VALUES (304, 'Evercrisp');

-- POBLAMIENTO DE TABLA CATEGORIA
INSERT INTO CATEGORIA (id_categoria, nombre) VALUES (502, 'Alimentos');
INSERT INTO CATEGORIA (id_categoria, nombre) VALUES (503, 'Lácteos');
INSERT INTO CATEGORIA (id_categoria, nombre) VALUES (504, 'Snacks');
INSERT INTO CATEGORIA (id_categoria, nombre) VALUES (505, 'Bebidas');

-- POBLAMIENTO TABLA PRODUCTO
INSERT INTO PRODUCTO 
(id_producto, nombre, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1111, 'Leche Sin Lactosa Descremada 1L', 1500, 'S', 5, 'S', 303, 503, 10102);

INSERT INTO PRODUCTO 
(id_producto, nombre, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1222, 'Gaseosa Pepsi 500ml', 900, 'N', 10, 'S', 302, 505, 10104);

INSERT INTO PRODUCTO 
(id_producto, nombre, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1333, 'Choco Crocs', 2500, 'N', 5, 'S', 304, 504, 10103);

INSERT INTO PRODUCTO 
(id_producto, nombre, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor) 
VALUES (1444, 'Nestum', 2100, 'S', 3, 'S', 301, 502, 10101);


-- POBLACION DE TABLA AFP
INSERT INTO AFP (nombre) VALUES ('AFP Habitat');
INSERT INTO AFP (nombre) VALUES ('AFP Cuprum');
INSERT INTO AFP (nombre) VALUES ('AFP Provida');
INSERT INTO AFP (nombre) VALUES ('AFP PlanVital');

-- POBLACION DE TABLA SALUD
INSERT INTO SALUD (id_salud, nombre) VALUES (seq_salud.NEXTVAL, 'Fonasa');
INSERT INTO SALUD (id_salud, nombre) VALUES (seq_salud.NEXTVAL, 'Isapre Colmena');
INSERT INTO SALUD (id_salud, nombre) VALUES (seq_salud.NEXTVAL, 'Isapre Banmédica');
INSERT INTO SALUD (id_salud, nombre) VALUES (seq_salud.NEXTVAL, 'Isapre Cruz Blanca');

-- POBLACION DE TABLA MEDIO_PAGO
INSERT INTO MEDIO_PAGO (id_mpago, nombre) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (id_mpago, nombre) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre) VALUES (14, 'Cheque');

-- POBLACION TABLA EMPLEADO 
INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '11111111-1', 'Marcela', 'González', 'Pérez', '15-03-2022', 950000, 80000, 'S', 'ADMINISTRATIVO', NULL, 2050, 210);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '22222222-2', 'José', 'Muñoz', 'Ramírez', '10-07-2021', 900000, 75000, 'S', 'ADMINISTRATIVO', NULL, 2060, 216);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '33333333-3', 'Verónica', 'Soto', 'Alarcón', '05-01-2020', 880000, 70000, 'S', 'VENDEDOR', 750, 2060, 228);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '44444444-4', 'Luis', 'Reyes', 'Fuentes', '01-04-2023', 560000, NULL, 'S', 'VENDEDOR', 750, 2070, 228);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '55555555-5', 'Claudia', 'Fernández', 'Lagos', '15-04-2023', 600000,NULL, 'S', 'VENDEDOR', 753, 2070, 216);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '66666666-6', 'Carlos', 'Navarro', 'Vega', '01-05-2023', 610000, NULL, 'S', 'ADMINISTRATIVO', 753, 2060, 210);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '77777777-7', 'Javiera', 'Pino', 'Rojas', '10-05-2023', 650000, NULL, 'S', 'ADMINISTRATIVO', 750, 2050, 210);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '88888888-8', 'Diego', 'Mella', 'Contreras', '12-05-2023', 620000, NULL, 'S', 'VENDEDOR', 750, 2060, 216);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '99999999-9', 'Fernanda', 'Salas', 'Herrera', '18-05-2023', 570000, NULL, 'S', 'VENDEDOR', 753, 2070, 228);

INSERT INTO EMPLEADO
(id_empleado, rut, nombre, apellido_p, apellido_m, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_empleado, cod_salud, cod_afp)
VALUES (seq_empleado.NEXTVAL, '10101010-0', 'Tomás', 'Vidal', 'Espinoza', '01-06-2023', 530000, NULL, 'S', 'VENDEDOR', NULL, 2050, 222);

-- POBLACION TABLA ADMINISTRATIVO CON SELECT 
INSERT INTO ADMINISTRATIVO (id_empleado)
SELECT id_empleado
FROM EMPLEADO
WHERE tipo_empleado = 'ADMINISTRATIVO';

-- POBLACION TABLA VENDEDOR
INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (756, 0.25);

INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (759, 0.20);

INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (762, 0.15);

INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (771, 0.1);

INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (774, 0.1);

INSERT INTO VENDEDOR (id_empleado, comision_venta)
VALUES (777, 0.0);

-- POBLACION TABLA VENTA
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES ('12-05-2023', 225990, 12, 771);

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES ('23-10-2023', 524990, 13, 777);

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES ('17-02-2023', 466990, 11, 759);

-- POBLACION DETALLE_VENTA
-- VENTA 5050 CON FECHA 12-05-2023
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5050, 1111, 1);  -- Leche Sin Lactosa Descremada
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5050, 1333, 2);  -- Choco crocs

-- VENTA 5053 CON FECHA 23-10-2023
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5053, 1222, 3);  -- Gaseosa Pepsi
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5053, 1444, 2);  -- Nestum
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5053, 1111, 2);  -- Leche Sin Lactosa Descremada

-- VENTA 5056 CON FECHA 17-02-2023
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5056, 1222, 2);  -- Gaseosa Pepsi
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad)
VALUES (5056, 1444, 3);  -- Nestum

-- CASO 4: RECUPERACION DE DATOS

-- INFORME 1

-- CREACION TABLA REPORTE PARA INFORME 1
CREATE TABLE REPORTE AS
-- SELECT TABLA EMPLEADO
SELECT 
    id_empleado AS "IDENTIFICADOR",
    nombre || ' ' || apellido_p || ' ' || apellido_m AS "NOMBRE COMPLETO",
    sueldo_base AS "SALARIO",
    bono_jefatura AS "BONIFICACION",
    sueldo_base + bono_jefatura AS "SALARIO SIMULADO"
FROM EMPLEADO
WHERE activo = 'S' AND bono_jefatura IS NOT NULL;

-- CONSULTA TABLA REPORTE
SELECT "IDENTIFICADOR", "NOMBRE COMPLETO", "SALARIO", "BONIFICACION", "SALARIO SIMULADO"
FROM (
    SELECT 
        id_empleado AS "IDENTIFICADOR",
        nombre || ' ' || apellido_p || ' ' || apellido_m AS "NOMBRE COMPLETO",
        sueldo_base AS "SALARIO",
        bono_jefatura AS "BONIFICACION",
        sueldo_base + bono_jefatura AS "SALARIO SIMULADO",
        apellido_p
    FROM EMPLEADO
    WHERE activo = 'S' AND bono_jefatura IS NOT NULL
)
ORDER BY "SALARIO SIMULADO" DESC, apellido_p DESC;

-- CREACION DE TABLA REPORTE2 PARA INFORME 2
CREATE TABLE REPORTE2 AS
SELECT
    nombre || ' ' || apellido_p || ' ' || apellido_m AS "EMPLEADO",
    sueldo_base AS "SUELDO",
    sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base + (sueldo_base * 0.08) AS "SALARIO SIMULADO"
FROM EMPLEADO
WHERE sueldo_base BETWEEN 550000 AND 800000;

-- CONSULTA TABLA REPORTE2
SELECT * 
FROM REPORTE2
ORDER BY "SUELDO" ASC;
