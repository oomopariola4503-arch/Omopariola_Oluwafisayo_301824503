-- Show related orders, customers, restaurants records (up to 20).
SELECT t0."id" AS "orders_id",
       t0."client_order_key" AS "orders_client_order_key",
       t1."id" AS "customers_id",
       t1."full_name" AS "customers_full_name",
       t2."id" AS "restaurants_id",
       t2."name" AS "restaurants_name"
FROM portfolio."orders" t0
JOIN portfolio."customers" t1 ON t0."customer_id" = t1."id"
JOIN portfolio."restaurants" t2 ON t0."restaurant_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "orders_id",
       t0."client_order_key" AS "orders_client_order_key",
       t1."id" AS "customers_id",
       t1."full_name" AS "customers_full_name",
       t2."id" AS "restaurants_id",
       t2."name" AS "restaurants_name"
FROM portfolio."orders" t0
JOIN portfolio."customers" t1 ON t0."customer_id" = t1."id"
JOIN portfolio."restaurants" t2 ON t0."restaurant_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find orders records where placed_at matches "2026-10-12T18:30:00Z" (up to 20).
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;

-- Count order_items records for each order_id (up to 20 groups).
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

-- Find orders records where placed_at matches "2026-10-12T18:30:00Z" (up to 20).
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;
