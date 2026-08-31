/* ============================================================
   M5 - CONSULTAS CON JOINS
   ============================================================ */

USE BaseVentas_Tech_DB;
GO

/* ============================================================
   CONSULTA 1 - VISTA BASE DEL PROYECTO
   INNER JOIN
   ============================================================ */

SELECT
    ventas.fecha_venta AS fecha,
    ventas.id_cliente AS id_cliente,
    clientes.nombre AS nombre_cliente,
    productos.nombre_producto AS producto,
    categorias.nombre_categoria AS categoria,
    territorios.zona AS zona,
    territorios.region AS region,
    ventas.cantidad AS cantidad,
    ventas.precio_unitario AS precio_unitario,
    ventas.cantidad * ventas.precio_unitario AS total_venta,
    clientes.edad AS edad_cliente,
    productos.promocion AS promocion,
    ventas.estado_compra AS estado_compra,
    ventas.tiempo_carrito AS tiempo_carrito,
    ventas.modificacion_producto AS modificacion_producto,
    ventas.tipo_modificacion AS tipo_modificacion,
    ventas.motivo_abandono AS motivo_abandono

FROM ventas

INNER JOIN clientes
    ON ventas.id_cliente = clientes.id_cliente

INNER JOIN productos
    ON ventas.id_producto = productos.id_producto

INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria

INNER JOIN territorios
    ON ventas.id_territorio = territorios.id_territorio;

GO


/* ============================================================
   CONSULTA 2 - CLIENTES SIN VENTAS
   LEFT JOIN
   ============================================================ */

SELECT
    clientes.nombre AS nombre_cliente,
    clientes.email AS email,
    clientes.fecha_registro AS fecha_registro

FROM clientes

LEFT JOIN ventas
    ON clientes.id_cliente = ventas.id_cliente

WHERE ventas.id_cliente IS NULL;

GO


/* ============================================================
   CONSULTA 3 - PRODUCTOS SIN VENTAS
   LEFT JOIN
   ============================================================ */

SELECT
    productos.nombre_producto AS producto,
    categorias.nombre_categoria AS categoria,
    productos.precio AS precio

FROM productos

INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria

LEFT JOIN ventas
    ON productos.id_producto = ventas.id_producto

WHERE ventas.id_producto IS NULL;

GO


/* ============================================================
   CONSULTA 4 - CONSOLIDADO POR CANAL
   UNION ALL
   ============================================================ */
SELECT
    canal,
    SUM(total) AS total
FROM (
    SELECT
        cantidad * precio_unitario AS total,
        'Centro' AS canal
    FROM ventas
    WHERE id_territorio IN (1, 2)

    UNION ALL

    SELECT
        cantidad * precio_unitario AS total,
        'Otras zonas' AS canal
    FROM ventas
    WHERE id_territorio IN (3, 4, 5)
) AS consolidado
GROUP BY canal;