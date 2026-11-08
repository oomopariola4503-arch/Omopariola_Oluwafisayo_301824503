-- Fictional sample records for Food Delivery / Restaurant Ordering System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."restaurants" ("id", "name", "slug", "address", "active") VALUES (101, 'Maple Table', 'maple-table', '12 Cedar Lane, Sampleton', TRUE);
INSERT INTO portfolio."customers" ("id", "full_name", "email", "phone") VALUES (201, 'Alex Rivera', 'alex.rivera@example.test', '+1-555-0101');
INSERT INTO portfolio."menu_items" ("id", "restaurant_id", "name", "price", "available") VALUES (301, 101, 'Garden Bowl', 12.5, TRUE);
INSERT INTO portfolio."orders" ("id", "customer_id", "restaurant_id", "client_order_key", "status", "placed_at", "delivery_address") VALUES (401, 201, 101, 'client-order-001', 'accepted', '2026-10-12T18:30:00Z', '45 Birch Street, Sampleton');
INSERT INTO portfolio."order_items" ("id", "order_id", "menu_item_id", "quantity", "unit_price") VALUES (501, 401, 301, 2, 12.5);
COMMIT;
