SELECT      order_purchase_timestamp,
            order_estimated_delivery_date,
            julianday(order_estimated_delivery_date) - julianday(order_purchase_timestamp)


FROM        tb_orders
 