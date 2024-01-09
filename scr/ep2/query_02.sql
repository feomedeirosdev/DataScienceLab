WITH        tb_idade_base AS (

    SELECT      t2.seller_id,
                CAST(max(julianday('2017-04-01') - julianday(t1.order_approved_at)) AS INT) AS idade_base_dias

    FROM        tb_orders AS t1

    LEFT JOIN   tb_order_items AS t2
    ON          t1.order_id = t2.order_id

    WHERE       t1.order_approved_at < '2017-04-01'
    AND         t1.order_status = 'delivered'

    GROUP BY    t2.seller_id

)

SELECT      t2.seller_id AS vendedor_id,
            t3.idade_base_dias,
            1 + CAST(t3.idade_base_dias / 30.4 AS INT) AS idade_base_omes,
            julianday('2017-04-01') - julianday(max(t1.order_approved_at)) AS qtd_dias_ultima_venda,

            count(DISTINCT strftime('%m', t1.order_approved_at)) AS qtd_meses_ativados,

            round((CAST(count(DISTINCT strftime('%m', t1.order_approved_at)) AS FLOAT) / min(1 + CAST(t3.idade_base_dias / 30.4 AS INT), 6) * 100), 2) AS prop_meses_ativados,

            round(sum(t2.price), 2) AS tot_receita_R$,
            round(sum(t2.price) / count(DISTINCT t2.order_id), 2) AS avg_vl_venda_R$,
            round((sum(t2.price) / min(1 + CAST(t3.idade_base_dias / 30.4 AS INT), 6)), 2) AS avg_vl_venda_mes_R$,

            round(sum(t2.price) / COUNT(DISTINCT strftime('%m', t1.order_approved_at)), 2) AS avg_vl_venda_mes_ativado_R$,

            count(DISTINCT t2.order_id) AS qdt_vendas,
            count(t2.product_id) AS qtd_produtos_vendidos,
            count(DISTINCT t2.product_id) AS qtde_produtos_distintos_vendidos,
            round(sum(t2.price) / count(t2.product_id), 2) AS avg_vl_produto_R$,
            count(t2.product_id) / count(DISTINCT t2.order_id) AS avg_qtd_produtos_venda

FROM        tb_orders AS t1

LEFT JOIN   tb_order_items AS t2
ON          t1.order_id = t2.order_id

LEFT JOIN   tb_idade_base AS t3
ON          t2.seller_id = t3.seller_id

WHERE       order_approved_at BETWEEN '2016-10-01' AND '2017-04-01'
AND         order_status = 'delivered'

GROUP BY    t2.seller_id