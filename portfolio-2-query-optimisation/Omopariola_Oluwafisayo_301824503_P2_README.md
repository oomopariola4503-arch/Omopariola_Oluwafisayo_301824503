# Food Delivery / Restaurant Ordering System — SQL queries

## 1. Show related orders, customers, restaurants records (up to 20).

```sql
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
```

| orders_id | orders_client_order_key | customers_id | customers_full_name | restaurants_id | restaurants_name |
| --- | --- | --- | --- | --- | --- |
| 401 | client-order-001 | 201 | Alex Rivera | 101 | Maple Table |

## 2. Find orders records where placed_at matches "2026-10-12T18:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;
```

| id | customer_id | restaurant_id | client_order_key | status | placed_at | delivery_address |
| --- | --- | --- | --- | --- | --- | --- |
| 401 | 201 | 101 | client-order-001 | accepted | 2026-10-12T18:30:00+00:00 | 45 Birch Street, Sampleton |

## 3. Count order_items records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_items"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 401 | 1 |

## 4. Find orders records where placed_at matches "2026-10-12T18:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-10-12T18:30:00Z'
ORDER BY "id"
LIMIT 20;
```

| id | customer_id | restaurant_id | client_order_key | status | placed_at | delivery_address |
| --- | --- | --- | --- | --- | --- | --- |
| 401 | 201 | 101 | client-order-001 | accepted | 2026-10-12T18:30:00+00:00 | 45 Birch Street, Sampleton |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.043 | 1.035, 1.043, 1.094 | Sort → Seq Scan | 112 |
| After index | 0.17 | 0.17, 0.17, 0.169 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.043 ms to 0.17 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.01..1.011 rows=20 loops=1)
  Seq Scan on orders (actual time=0.015..0.976 rows=20 loops=1)
Planning Time: 0.369 ms
Execution Time: 1.035 ms
```

### Before index, run 2

```text
Sort (actual time=1.016..1.017 rows=20 loops=1)
  Seq Scan on orders (actual time=0.015..0.973 rows=20 loops=1)
Planning Time: 0.373 ms
Execution Time: 1.043 ms
```

### Before index, run 3

```text
Sort (actual time=1.062..1.065 rows=20 loops=1)
  Seq Scan on orders (actual time=0.016..1.019 rows=20 loops=1)
Planning Time: 0.486 ms
Execution Time: 1.094 ms
```

### After index, run 1

```text
Sort (actual time=0.12..0.121 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.022..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=20 loops=1)
Planning Time: 0.595 ms
Execution Time: 0.17 ms
```

### After index, run 2

```text
Sort (actual time=0.119..0.121 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.022..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.589 ms
Execution Time: 0.17 ms
```

### After index, run 3

```text
Sort (actual time=0.118..0.12 rows=20 loops=1)
  Bitmap Heap Scan on orders (actual time=0.022..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=20 loops=1)
Planning Time: 0.578 ms
Execution Time: 0.169 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Omopariola_Oluwafisayo_301824503_P2_Queries.sql, then Omopariola_Oluwafisayo_301824503_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Omopariola_Oluwafisayo_301824503_P2_QueryResults.png) · [Index comparison](screenshots/Omopariola_Oluwafisayo_301824503_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

