-- Food Delivery / Restaurant Ordering System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."restaurants" (
  "id" bigint NOT NULL,
  "name" text NOT NULL,
  "slug" text NOT NULL,
  "address" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_restaurants" PRIMARY KEY ("id"),
  CONSTRAINT "uq_restaurants_0" UNIQUE ("slug")
);
CREATE TABLE portfolio."customers" (
  "id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text,
  CONSTRAINT "pk_customers" PRIMARY KEY ("id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("email")
);
CREATE TABLE portfolio."menu_items" (
  "id" bigint NOT NULL,
  "restaurant_id" bigint NOT NULL,
  "name" text NOT NULL,
  "price" numeric(18,2) NOT NULL,
  "available" boolean NOT NULL,
  CONSTRAINT "pk_menu_items" PRIMARY KEY ("id"),
  CONSTRAINT "uq_menu_items_0" UNIQUE ("restaurant_id", "name")
);
CREATE TABLE portfolio."orders" (
  "id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "restaurant_id" bigint NOT NULL,
  "client_order_key" text NOT NULL,
  "status" text NOT NULL,
  "placed_at" timestamptz NOT NULL,
  "delivery_address" text NOT NULL,
  CONSTRAINT "pk_orders" PRIMARY KEY ("id"),
  CONSTRAINT "uq_orders_0" UNIQUE ("client_order_key")
);
CREATE TABLE portfolio."order_items" (
  "id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "menu_item_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_items" PRIMARY KEY ("id"),
  CONSTRAINT "uq_order_items_0" UNIQUE ("order_id", "menu_item_id")
);
ALTER TABLE portfolio."menu_items" ADD CONSTRAINT "fk_menu_items_0" FOREIGN KEY ("restaurant_id") REFERENCES portfolio."restaurants" ("id");
ALTER TABLE portfolio."orders" ADD CONSTRAINT "fk_orders_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("id");
ALTER TABLE portfolio."orders" ADD CONSTRAINT "fk_orders_1" FOREIGN KEY ("restaurant_id") REFERENCES portfolio."restaurants" ("id");
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "fk_order_items_0" FOREIGN KEY ("order_id") REFERENCES portfolio."orders" ("id");
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "fk_order_items_1" FOREIGN KEY ("menu_item_id") REFERENCES portfolio."menu_items" ("id");
ALTER TABLE portfolio."menu_items" ADD CONSTRAINT "ck_menu_price_positive" CHECK ("price" > 0);
ALTER TABLE portfolio."orders" ADD CONSTRAINT "ck_order_status" CHECK (("status" = 'pending') OR (("status" = 'accepted') OR (("status" = 'preparing') OR (("status" = 'delivered') OR ("status" = 'cancelled')))));
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "ck_order_item_quantity" CHECK ("quantity" > 0);
ALTER TABLE portfolio."order_items" ADD CONSTRAINT "ck_order_item_price" CHECK ("unit_price" > 0);
COMMIT;
