-- =========================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- =========================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- =========================================
-- CONSULTA 2: Ranking de productos
-- =========================================

SELECT TOP 5
    id_producto,
    SUM(cantidad * precio_unitario) AS total_facturado,
    SUM(cantidad) AS unidades_vendidas
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- =========================================
-- CONSULTA 3: Clientes recurrentes
-- =========================================

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;




-- =========================================
-- CONSULTA 4: Meses por encima/por debajo
-- =========================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,

    CASE
        WHEN SUM(cantidad * precio_unitario) >
        (
            SELECT AVG(total_facturado)
            FROM
            (
                SELECT
                    MONTH(fecha_venta) AS mes,
                    SUM(cantidad * precio_unitario) AS total_facturado
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS tabla_meses
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion

FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- =========================================
-- HALLAZGOS
-- =========================================

-- Hallazgo 1: El producto 1 es el de mayor facturación, con un total de $3,600.

-- Hallazgo 2: El producto 2 registra 13 unidades vendidas, pero genera solo $364,
-- lo que muestra que un mayor volumen de unidades no necesariamente implica mayor facturación.

-- Hallazgo 3: Todos los clientes registrados realizaron 2 pedidos.
-- El cliente 1 presenta el mayor gasto total, con $2,640.