SELECT      t2.seller_id,
            min(t1.order_approved_at) AS dt_1a_venda,
            CAST(max(julianday('2017-04-01') - julianday(t1.order_approved_at)) AS INT) AS idade_base_dias

FROM        tb_orders AS t1

LEFT JOIN   tb_order_items AS t2
ON          t1.order_id = t2.order_id

WHERE       t1.order_approved_at < '2017-04-01'
AND         t1.order_status = 'delivered'

GROUP BY    t2.seller_id