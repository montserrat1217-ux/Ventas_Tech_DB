USE Ventas_Tech_DB;
GO

-- =========================================
-- m5_consultas_joins
-- Autor: Montserrat Resendiz
-- =========================================

--Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre AS nombre_cliente,
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias ca
    ON p.id_categoria = ca.id_categoria;

--Consulta 2 — Clientes sin ventas (LEFT JOIN) 
--Identificá clientes registrados que aún no han realizado ninguna compra. 
--Mostrá su nombre, email y fecha de registro. 
--Usá WHERE ... IS NULL para aislar los casos.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Consulta 3 — Productos sin ventas (LEFT JOIN) 
--Identificá productos del catálogo que no tienen 
--ninguna venta registrada. Mostrá nombre del producto, 
--categoría y precio. Usá WHERE ... IS NULL.

SELECT
    p.nombre_producto,
    ca.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN categorias ca
    ON p.id_categoria = ca.id_categoria
WHERE v.id_venta IS NULL;

--Consulta 4 — Consolidado por canal (UNION ALL)

SELECT
    v.fecha_venta,
    v.cantidad * v.precio_unitario AS total,
    'Buenos Aires' AS canal
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
WHERE c.ciudad = 'Buenos Aires'

UNION ALL

SELECT
    v.fecha_venta,
    v.cantidad * v.precio_unitario AS total,
    'Interior' AS canal
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
WHERE c.ciudad IN ('Córdoba', 'Mendoza', 'Rosario', 'Tucumán');

SELECT
    canal,
    SUM(total) AS total_por_canal
FROM (
    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Buenos Aires' AS canal
    FROM ventas v
    INNER JOIN clientes c
        ON v.id_cliente = c.id_cliente
    WHERE c.ciudad = 'Buenos Aires'

    UNION ALL

    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Interior' AS canal
    FROM ventas v
    INNER JOIN clientes c
        ON v.id_cliente = c.id_cliente
    WHERE c.ciudad IN ('Córdoba', 'Mendoza', 'Rosario', 'Tucumán')

) AS consolidado
GROUP BY canal;
