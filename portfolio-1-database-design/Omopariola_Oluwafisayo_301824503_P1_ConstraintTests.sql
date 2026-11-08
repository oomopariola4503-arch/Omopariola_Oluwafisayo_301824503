-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject pk restaurants. Expected: pk_restaurants, SQLSTATE 23505.
INSERT INTO portfolio."restaurants" ("id", "name", "slug", "address", "active")
VALUES (101, 'Juniper Cafe', 'juniper-cafe', '2 Pine Road, Sampleton', TRUE);

-- 2. reject uq restaurants slug. Expected: uq_restaurants_0, SQLSTATE 23505.
INSERT INTO portfolio."restaurants" ("id", "name", "slug", "address", "active")
VALUES (1101, 'Maple Table Annex', 'maple-table', '8 Oak Avenue, Sampleton', TRUE);

-- 3. reject nn restaurants name. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."restaurants" ("id", "name", "slug", "address", "active")
VALUES (1301, NULL, 'null-name-cafe', '7 Elm Street, Sampleton', TRUE);

-- 4. reject pk customers. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "full_name", "email", "phone")
VALUES (201, 'Morgan Lee', 'morgan.lee@example.test', '+1-555-0102');

-- 5. reject uq customers email. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "full_name", "email", "phone")
VALUES (1102, 'Taylor Quinn', 'alex.rivera@example.test', '+1-555-0103');

-- 6. reject pk menu items. Expected: pk_menu_items, SQLSTATE 23505.
INSERT INTO portfolio."menu_items" ("id", "restaurant_id", "name", "price", "available")
VALUES (301, 101, 'Tomato Soup', 6.25, TRUE);

-- 7. reject uq menu items name. Expected: uq_menu_items_0, SQLSTATE 23505.
INSERT INTO portfolio."menu_items" ("id", "restaurant_id", "name", "price", "available")
VALUES (1103, 101, 'Garden Bowl', 13.5, FALSE);

-- 8. reject fk menu items restaurant. Expected: fk_menu_items_0, SQLSTATE 23503.
INSERT INTO portfolio."menu_items" ("id", "restaurant_id", "name", "price", "available")
VALUES (1201, 999001, 'Roasted Carrots', 7.25, TRUE);

-- 9. reject pk orders. Expected: pk_orders, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address")
VALUES (401, 201, 101, 'client-order-pk-test', 'pending', '2026-10-13T12:00:00Z', '9 Willow Way, Sampleton');

-- 10. reject uq orders client key. Expected: uq_orders_0, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address")
VALUES (1104, 201, 101, 'client-order-001', 'pending', '2026-10-13T12:05:00Z', '10 Willow Way, Sampleton');

-- 11. reject fk orders customer. Expected: fk_orders_0, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address")
VALUES (1202, 999002, 101, 'client-order-fk-customer', 'pending', '2026-10-14T09:00:00Z', '11 Willow Way, Sampleton');

-- 12. reject fk orders restaurant. Expected: fk_orders_1, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address")
VALUES (1203, 201, 999003, 'client-order-fk-restaurant', 'pending', '2026-10-14T09:05:00Z', '12 Willow Way, Sampleton');

-- 13. reject pk order items. Expected: pk_order_items, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (501, 401, 301, 1, 12.5);

-- 14. reject uq order items pair. Expected: uq_order_items_0, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (1105, 401, 301, 3, 12.5);

-- 15. reject fk order items order. Expected: fk_order_items_0, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (1204, 999004, 301, 1, 12.5);

-- 16. reject fk order items menu. Expected: fk_order_items_1, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (1205, 401, 999005, 1, 12.5);

-- 17. reject ck menu price. Expected: ck_menu_price_positive, SQLSTATE 23514.
INSERT INTO portfolio."menu_items" ("id", "restaurant_id", "name", "price", "available")
VALUES (1401, 101, 'Price Test Item', 0, TRUE);

-- 18. reject ck order status. Expected: ck_order_status, SQLSTATE 23514.
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address")
VALUES (1402, 201, 101, 'client-order-status-test', 'shipped', '2026-10-15T10:00:00Z', '13 Willow Way, Sampleton');

-- 19. reject ck order item quantity. Expected: ck_order_item_quantity, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (1403, 401, 301, 0, 12.5);

-- 20. reject ck order item price. Expected: ck_order_item_price, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (1404, 401, 301, 1, 0);
