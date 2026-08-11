/* ============================================================
   VENTAS_TECH_DB
   Proyecto Final - Data Analyst
   Empresa: TechStore

   Modelo:
   Dimensiones:
   - categorias
   - clientes
   - productos
   - territorios

   Tabla de hechos:
   - ventas
   ============================================================ */


/* ============================================================
   1. CREAR BASE DE DATOS
   ============================================================ */

CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO


/* ============================================================
   2. DROP TABLES
   Se eliminan primero las tablas que dependen de otras
   ============================================================ */

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS dbo.DimProductos;
DROP TABLE IF EXISTS dbo.DimClientes;
DROP TABLE IF EXISTS dbo.DimTerritorios;
DROP TABLE IF EXISTS dbo.DimCategorias;
GO


/* ============================================================
   3. CREAR TABLAS DIMENSIÓN
   ============================================================ */


/* ------------------------------------------------------------
   DIMENSIÓN CATEGORÍAS
   ------------------------------------------------------------ */

CREATE TABLE dbo.DimCategorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);


/* ------------------------------------------------------------
   DIMENSIÓN CLIENTES
   Se agrega edad para analizar las características de los
   clientes que abandonan o modifican una compra.
   ------------------------------------------------------------ */

CREATE TABLE dbo.DimClientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL,
    edad INT NOT NULL
);


/* ------------------------------------------------------------
   DIMENSIÓN PRODUCTOS
   Se agrega promocion para analizar si las promociones
   influyen en el abandono o modificación de compras.
   ------------------------------------------------------------ */

CREATE TABLE dbo.DimProductos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,
    promocion TINYINT DEFAULT 0,

    CONSTRAINT FK_Productos_Categorias
        FOREIGN KEY (id_categoria)
        REFERENCES dbo.DimCategorias(id_categoria)
);


/* ------------------------------------------------------------
   DIMENSIÓN TERRITORIOS
   Permite analizar diferencias de abandono o modificación
   según zona o región.
   ------------------------------------------------------------ */

CREATE TABLE dbo.DimTerritorios (
    id_territorio INT PRIMARY KEY,
    zona VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

GO


/* ============================================================
   4. CREAR TABLA DE HECHOS
   ============================================================ */

CREATE TABLE dbo.FactVentas (
    id_venta INT PRIMARY KEY,

    fecha_venta DATE NOT NULL,

    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    id_territorio INT NOT NULL,

    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,

    hora_compra TIME,
    estado_compra VARCHAR(20),
    tiempo_carrito INT,
    modificacion_producto TINYINT NOT NULL DEFAULT 0,
    tipo_modificacion VARCHAR(30) NULL,
    motivo_abandono VARCHAR(50) NULL,

    /* Foreign Keys */

    CONSTRAINT FK_Ventas_Clientes
        FOREIGN KEY (id_cliente)
        REFERENCES dbo.DimClientes(id_cliente),

    CONSTRAINT FK_Ventas_Productos
        FOREIGN KEY (id_producto)
        REFERENCES dbo.DimProductos(id_producto),

    CONSTRAINT FK_Ventas_Territorios
        FOREIGN KEY (id_territorio)
        REFERENCES dbo.DimTerritorios(id_territorio)
);

GO


/* ============================================================
   5. INSERT DATA
   ============================================================ */


/* ------------------------------------------------------------
   CATEGORÍAS
   4 registros
   ------------------------------------------------------------ */

INSERT INTO dbo.DimCategorias
VALUES
(1, 'Computación', 'Laptops, PCs y monitores'),
(2, 'Accesorios', 'Periféricos y complementos'),
(3, 'Audio', 'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');

GO


/* ------------------------------------------------------------
   CLIENTES
   5 registros
   ------------------------------------------------------------ */

INSERT INTO dbo.DimClientes
VALUES
(1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05', 28),
(2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10', 35),
(3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01', 24),
(4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15', 42),
(5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01', 31);

GO


/* ------------------------------------------------------------
   PRODUCTOS
   6 registros
   ------------------------------------------------------------ */

INSERT INTO dbo.DimProductos
VALUES
(1, 'Laptop Pro 15',      1, 1200.00, 15, 1, 1),
(2, 'Mouse Inalámbrico',  2,   28.00, 80, 1, 0),
(3, 'Monitor 4K 27"',     1,  450.00, 12, 1, 1),
(4, 'Auriculares BT Pro', 3,  120.00, 35, 1, 0),
(5, 'SSD Externo 1TB',    4,  130.00, 18, 1, 1),
(6, 'Teclado Mecánico',   2,   95.00, 40, 1, 0);

GO


/* ------------------------------------------------------------
   TERRITORIOS
   5 registros
   ------------------------------------------------------------ */

INSERT INTO dbo.DimTerritorios
VALUES
(1, 'Centro', 'Buenos Aires'),
(2, 'Centro', 'Córdoba'),
(3, 'Litoral', 'Rosario'),
(4, 'Cuyo', 'Mendoza'),
(5, 'Norte', 'Tucumán');

GO


/* ============================================================
   VENTAS
   10 registros
   ============================================================ */

INSERT INTO dbo.FactVentas
(
    id_venta,
    fecha_venta,
    id_cliente,
    id_producto,
    id_territorio,
    cantidad,
    precio_unitario,
    hora_compra,
    estado_compra,
    tiempo_carrito,
    modificacion_producto,
    tipo_modificacion,
    motivo_abandono
)
VALUES
(1, '2024-03-05', 1, 1, 1, 2, 1200.00, '10:30:00', 'Completada', 8, 0, NULL, NULL),

(2, '2024-03-06', 2, 2, 2, 5, 28.00, '11:15:00', 'Completada', 12, 0, NULL, NULL),

(3, '2024-03-07', 3, 3, 3, 1, 450.00, '12:20:00', 'Modificada', 25, 1, 'Sustitución', NULL),

(4, '2024-03-08', 1, 4, 1, 2, 120.00, '13:10:00', 'Completada', 6, 0, NULL, NULL),

(5, '2024-03-10', 4, 5, 4, 3, 130.00, '14:30:00', 'Abandonada', 42, 0, NULL, 'Precio'),

(6, '2024-03-11', 2, 6, 2, 4, 95.00, '15:20:00', 'Completada', 15, 0, NULL, NULL),

(7, '2024-03-12', 5, 1, 5, 1, 1200.00, '16:45:00', 'Modificada', 31, 1, 'Eliminación', NULL),

(8, '2024-03-13', 3, 2, 3, 8, 28.00, '17:10:00', 'Completada', 9, 0, NULL, NULL),

(9, '2024-03-14', 4, 4, 4, 1, 120.00, '18:30:00', 'Abandonada', 48, 0, NULL, 'Falta de stock'),

(10, '2024-03-15', 5, 3, 5, 2, 450.00, '19:15:00', 'Completada', 18, 0, NULL, NULL);

/* ============================================================
   6. VERIFICACIÓN 
   ============================================================ */


/* Verificar Categorías */
SELECT * FROM dbo.DimCategorias;


/* Verificar Clientes */
SELECT * FROM dbo.DimClientes;


/* Verificar Productos */
SELECT * FROM dbo.DimProductos;


/* Verificar Territorios */
SELECT * FROM dbo.DimTerritorios;


/* Verificar Ventas */
SELECT * FROM dbo.FactVentas;

GO
