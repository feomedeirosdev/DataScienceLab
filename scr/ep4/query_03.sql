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

SELECT      t2.seller_id AS vendedor_id, -- vendedor
            seller_city AS cidade, -- cidade do vendedor
            seller_state AS estado, -- estado do vendedor
            avg(t6.review_score) AS avg_review_score, -- média da pontuação
            t3.idade_base_dias, -- idade do vendedor em dias (após a primeira venda)
            1 + CAST(t3.idade_base_dias / 30.4 AS INT) AS idade_base_omes, -- mes ativo
            CAST(julianday('2017-04-01') - julianday(max(t1.order_approved_at)) AS INT) AS qtd_dias_ultima_venda, -- dias da última venda

            count(DISTINCT strftime('%m', t1.order_approved_at)) AS qtd_meses_ativados, -- quantidades de meses onde foi realizado vendas

            round((CAST(count(DISTINCT strftime('%m', t1.order_approved_at)) AS FLOAT) / min(1 + CAST(t3.idade_base_dias / 30.4 AS INT), 6) * 100), 2) AS prop_meses_ativados, -- proporção dos meses ativados

            sum(CASE WHEN julianday(t1.order_estimated_delivery_date) < julianday(t1.order_delivered_customer_date) THEN 1 ELSE 0 END) AS qtd_pedidos_atrasados, -- quantidade de pedidos atrasados
            count(DISTINCT t2.order_id) AS qdt_vendas, -- quantidade de vendas
            sum(CASE WHEN julianday(t1.order_estimated_delivery_date) < julianday(t1.order_delivered_customer_date) THEN 1 ELSE 0 END) / count(DISTINCT t2.order_id) AS prop_pedidos_atrasados, -- proporção de pedidos atrasados

            CAST(avg(julianday(t1.order_estimated_delivery_date) - julianday(t1.order_purchase_timestamp)) AS INT) AS avg_tempo_est_entrega_dias, -- tempo estimado de entrega

            round(sum(t2.price), 2) AS tot_receita_R$, -- receita total gerada
            round(sum(t2.price) / count(DISTINCT t2.order_id), 2) AS avg_vl_venda_R$, -- média do valor das vendas
            round((sum(t2.price) / min(1 + CAST(t3.idade_base_dias / 30.4 AS INT), 6)), 2) AS avg_vl_venda_mes_R$, -- média de valor de venda por mês

            round(sum(t2.price) / COUNT(DISTINCT strftime('%m', t1.order_approved_at)), 2) AS avg_vl_venda_mes_ativado_R$, -- média do valor de venda por mes que foi ativado

            count(DISTINCT t2.order_id) AS qdt_vendas, -- quantidade de vendas realizadas
            count(t2.product_id) AS qtd_produtos_vendidos, -- quantidade de produtos vendidos
            count(DISTINCT t2.product_id) AS qtde_produtos_distintos_vendidos, -- quantidade de produtos distintos vendidos
            round(sum(t2.price) / count(t2.product_id), 2) AS avg_vl_produto_R$, -- média do valor por produto
            count(t2.product_id) / count(DISTINCT t2.order_id) AS avg_qtd_produtos_venda, -- média da quantidade de produtos por venda

            /* PUTEIRO */
            sum(CASE WHEN t4.product_category_name = 'agro_industria_e_comercio' THEN 1 ELSE 0 END) AS qtd_agro_industria_e_comercio,
            sum(CASE WHEN t4.product_category_name = 'alimentos' THEN 1 ELSE 0 END) AS qtd_alimentos,
            sum(CASE WHEN t4.product_category_name = 'alimentos_bebidas' THEN 1 ELSE 0 END) AS qtd_alimentos_bebidas,
            sum(CASE WHEN t4.product_category_name = 'artes' THEN 1 ELSE 0 END) AS qtd_artes,
            sum(CASE WHEN t4.product_category_name = 'artes_e_artesanato' THEN 1 ELSE 0 END) AS qtd_artes_e_artesanato,
            sum(CASE WHEN t4.product_category_name = 'artigos_de_festas' THEN 1 ELSE 0 END) AS qtd_artigos_de_festas,
            sum(CASE WHEN t4.product_category_name = 'artigos_de_natal' THEN 1 ELSE 0 END) AS qtd_artigos_de_natal,
            sum(CASE WHEN t4.product_category_name = 'audio' THEN 1 ELSE 0 END) AS qtd_audio,
            sum(CASE WHEN t4.product_category_name = 'automotivo' THEN 1 ELSE 0 END) AS qtd_automotivo,
            sum(CASE WHEN t4.product_category_name = 'bebes' THEN 1 ELSE 0 END) AS qtd_bebes,
            sum(CASE WHEN t4.product_category_name = 'bebidas' THEN 1 ELSE 0 END) AS qtd_bebidas,
            sum(CASE WHEN t4.product_category_name = 'beleza_saude' THEN 1 ELSE 0 END) AS qtd_beleza_saude,
            sum(CASE WHEN t4.product_category_name = 'brinquedos' THEN 1 ELSE 0 END) AS qtd_brinquedos,
            sum(CASE WHEN t4.product_category_name = 'cama_mesa_banho' THEN 1 ELSE 0 END) AS qtd_cama_mesa_banho,
            sum(CASE WHEN t4.product_category_name = 'casa_conforto' THEN 1 ELSE 0 END) AS qtd_casa_conforto,
            sum(CASE WHEN t4.product_category_name = 'casa_conforto_2' THEN 1 ELSE 0 END) AS qtd_casa_conforto_2,
            sum(CASE WHEN t4.product_category_name = 'casa_construcao' THEN 1 ELSE 0 END) AS qtd_casa_construcao,
            sum(CASE WHEN t4.product_category_name = 'cds_dvds_musicais' THEN 1 ELSE 0 END) AS qtd_cds_dvds_musicais,
            sum(CASE WHEN t4.product_category_name = 'cine_foto' THEN 1 ELSE 0 END) AS qtd_cine_foto,
            sum(CASE WHEN t4.product_category_name = 'climatizacao' THEN 1 ELSE 0 END) AS qtd_climatizacao,
            sum(CASE WHEN t4.product_category_name = 'consoles_games' THEN 1 ELSE 0 END) AS qtd_consoles_games,
            sum(CASE WHEN t4.product_category_name = 'construcao_ferramentas_construcao' THEN 1 ELSE 0 END) AS qtd_construcao_ferramentas_construcao,
            sum(CASE WHEN t4.product_category_name = 'construcao_ferramentas_ferramentas' THEN 1 ELSE 0 END) AS qtd_construcao_ferramentas_ferramentas,
            sum(CASE WHEN t4.product_category_name = 'construcao_ferramentas_iluminacao' THEN 1 ELSE 0 END) AS qtd_construcao_ferramentas_iluminacao,
            sum(CASE WHEN t4.product_category_name = 'construcao_ferramentas_jardim' THEN 1 ELSE 0 END) AS qtd_construcao_ferramentas_jardim,
            sum(CASE WHEN t4.product_category_name = 'construcao_ferramentas_seguranca' THEN 1 ELSE 0 END) AS qtd_construcao_ferramentas_seguranca,
            sum(CASE WHEN t4.product_category_name = 'cool_stuff' THEN 1 ELSE 0 END) AS qtd_cool_stuff,
            sum(CASE WHEN t4.product_category_name = 'descategorizados' THEN 1 ELSE 0 END) AS qtd_descategorizados,
            sum(CASE WHEN t4.product_category_name = 'dvds_blu_ray' THEN 1 ELSE 0 END) AS qtd_dvds_blu_ray,
            sum(CASE WHEN t4.product_category_name = 'eletrodomesticos' THEN 1 ELSE 0 END) AS qtd_eletrodomesticos,
            sum(CASE WHEN t4.product_category_name = 'eletrodomesticos_2' THEN 1 ELSE 0 END) AS qtd_eletrodomesticos_2,
            sum(CASE WHEN t4.product_category_name = 'eletronicos' THEN 1 ELSE 0 END) AS qtd_eletronicos,
            sum(CASE WHEN t4.product_category_name = 'eletroportateis' THEN 1 ELSE 0 END) AS qtd_eletroportateis,
            sum(CASE WHEN t4.product_category_name = 'esporte_lazer' THEN 1 ELSE 0 END) AS qtd_esporte_lazer,
            sum(CASE WHEN t4.product_category_name = 'fashion_bolsas_e_acessorios' THEN 1 ELSE 0 END) AS qtd_fashion_bolsas_e_acessorios,
            sum(CASE WHEN t4.product_category_name = 'fashion_calcados' THEN 1 ELSE 0 END) AS qtd_fashion_calcados,
            sum(CASE WHEN t4.product_category_name = 'fashion_esporte' THEN 1 ELSE 0 END) AS qtd_fashion_esporte,
            sum(CASE WHEN t4.product_category_name = 'fashion_roupa_feminina' THEN 1 ELSE 0 END) AS qtd_fashion_roupa_feminina,
            sum(CASE WHEN t4.product_category_name = 'fashion_roupa_infanto_juvenil' THEN 1 ELSE 0 END) AS qtd_fashion_roupa_infanto_juvenil,
            sum(CASE WHEN t4.product_category_name = 'fashion_roupa_masculina' THEN 1 ELSE 0 END) AS qtd_fashion_roupa_masculina,
            sum(CASE WHEN t4.product_category_name = 'fashion_underwear_e_moda_praia' THEN 1 ELSE 0 END) AS qtd_fashion_underwear_e_moda_praia,
            sum(CASE WHEN t4.product_category_name = 'ferramentas_jardim' THEN 1 ELSE 0 END) AS qtd_ferramentas_jardim,
            sum(CASE WHEN t4.product_category_name = 'flores' THEN 1 ELSE 0 END) AS qtd_flores,
            sum(CASE WHEN t4.product_category_name = 'fraldas_higiene' THEN 1 ELSE 0 END) AS qtd_fraldas_higiene,
            sum(CASE WHEN t4.product_category_name = 'industria_comercio_e_negocios' THEN 1 ELSE 0 END) AS qtd_industria_comercio_e_negocios,
            sum(CASE WHEN t4.product_category_name = 'informatica_acessorios' THEN 1 ELSE 0 END) AS qtd_informatica_acessorios,
            sum(CASE WHEN t4.product_category_name = 'instrumentos_musicais' THEN 1 ELSE 0 END) AS qtd_instrumentos_musicais,
            sum(CASE WHEN t4.product_category_name = 'la_cuisine' THEN 1 ELSE 0 END) AS qtd_la_cuisine,
            sum(CASE WHEN t4.product_category_name = 'livros_importados' THEN 1 ELSE 0 END) AS qtd_livros_importados,
            sum(CASE WHEN t4.product_category_name = 'livros_interesse_geral' THEN 1 ELSE 0 END) AS qtd_livros_interesse_geral,
            sum(CASE WHEN t4.product_category_name = 'livros_tecnicos' THEN 1 ELSE 0 END) AS qtd_livros_tecnicos,
            sum(CASE WHEN t4.product_category_name = 'malas_acessorios' THEN 1 ELSE 0 END) AS qtd_malas_acessorios,
            sum(CASE WHEN t4.product_category_name = 'market_place' THEN 1 ELSE 0 END) AS qtd_market_place,
            sum(CASE WHEN t4.product_category_name = 'moveis_colchao_e_estofado' THEN 1 ELSE 0 END) AS qtd_moveis_colchao_e_estofado,
            sum(CASE WHEN t4.product_category_name = 'moveis_cozinha_area_de_servico_jantar_e_jardim' THEN 1 ELSE 0 END) AS qtd_moveis_cozinha_area_de_servico_jantar_e_jardim,
            sum(CASE WHEN t4.product_category_name = 'moveis_decoracao' THEN 1 ELSE 0 END) AS qtd_moveis_decoracao,
            sum(CASE WHEN t4.product_category_name = 'moveis_escritorio' THEN 1 ELSE 0 END) AS qtd_moveis_escritorio,
            sum(CASE WHEN t4.product_category_name = 'moveis_quarto' THEN 1 ELSE 0 END) AS qtd_moveis_quarto,
            sum(CASE WHEN t4.product_category_name = 'moveis_sala' THEN 1 ELSE 0 END) AS qtd_moveis_sala,
            sum(CASE WHEN t4.product_category_name = 'musica' THEN 1 ELSE 0 END) AS qtd_musica,
            sum(CASE WHEN t4.product_category_name = 'papelaria' THEN 1 ELSE 0 END) AS qtd_papelaria,
            sum(CASE WHEN t4.product_category_name = 'pc_gamer' THEN 1 ELSE 0 END) AS qtd_pc_gamer,
            sum(CASE WHEN t4.product_category_name = 'pcs' THEN 1 ELSE 0 END) AS qtd_pcs,
            sum(CASE WHEN t4.product_category_name = 'perfumaria' THEN 1 ELSE 0 END) AS qtd_perfumaria,
            sum(CASE WHEN t4.product_category_name = 'pet_shop' THEN 1 ELSE 0 END) AS qtd_pet_shop,
            sum(CASE WHEN t4.product_category_name = 'portateis_casa_forno_e_cafe' THEN 1 ELSE 0 END) AS qtd_portateis_casa_forno_e_cafe,
            sum(CASE WHEN t4.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos' THEN 1 ELSE 0 END) AS qtd_portateis_cozinha_e_preparadores_de_alimentos,
            sum(CASE WHEN t4.product_category_name = 'relogios_presentes' THEN 1 ELSE 0 END) AS qtd_relogios_presentes,
            sum(CASE WHEN t4.product_category_name = 'seguros_e_servicos' THEN 1 ELSE 0 END) AS qtd_seguros_e_servicos,
            sum(CASE WHEN t4.product_category_name = 'sinalizacao_e_seguranca' THEN 1 ELSE 0 END) AS qtd_sinalizacao_e_seguranca,
            sum(CASE WHEN t4.product_category_name = 'tablets_impressao_imagem' THEN 1 ELSE 0 END) AS qtd_tablets_impressao_imagem,
            sum(CASE WHEN t4.product_category_name = 'telefonia' THEN 1 ELSE 0 END) AS qtd_telefonia,
            sum(CASE WHEN t4.product_category_name = 'telefonia_fixa' THEN 1 ELSE 0 END) AS qtd_telefonia_fixa,
            sum(CASE WHEN t4.product_category_name = 'utilidades_domesticas' THEN 1 ELSE 0 END) AS qtd_utilidades_domestias

FROM        tb_orders AS t1

LEFT JOIN   tb_order_items AS t2
ON          t1.order_id = t2.order_id

LEFT JOIN   tb_idade_base AS t3
ON          t2.seller_id = t3.seller_id

LEFT JOIN   tb_products AS t4
ON          t2.product_id = t4.product_id

LEFT JOIN   tb_sellers AS t5
ON          t2.seller_id = t5.seller_id

LEFT JOIN   tb_order_reviews AS t6
ON          t1.order_id = t6.order_id

WHERE       order_approved_at BETWEEN '2016-10-01' AND '2017-04-01'
AND         order_status = 'delivered'

GROUP BY    t2.seller_id

ORDER BY    t4.product_category_name