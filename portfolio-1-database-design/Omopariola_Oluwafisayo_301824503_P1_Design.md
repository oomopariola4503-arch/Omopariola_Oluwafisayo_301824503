# Food Delivery / Restaurant Ordering System — database design

My case study records restaurants, customers, menu_items, orders, order_items.

## Users

- Customers browsing restaurant menus and placing orders
- Restaurant staff reviewing orders and menu availability
- Analysts reviewing order and menu-item sales

## Main operations

- Browse available menu items by restaurant
- Place an order with one or more menu items
- Review recent orders and aggregate delivered-item sales

## Entities

| Entity | Information stored |
| --- | --- |
| restaurants | Restaurants offering menu items and receiving customer orders. |
| customers | Customers who place restaurant orders. |
| menu_items | Restaurant menu entries, with the current price and availability. |
| orders | Customer orders placed with a restaurant. |
| order_items | Menu-item lines belonging to an order, including the placed-price snapshot. |

## restaurants

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| slug | TEXT | Unique | Yes |
| address | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (slug).

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| phone | TEXT |  | No |
- Unique key: (email).

## menu_items

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| restaurant_id | BIGINT | FK | Yes |
| name | TEXT |  | Yes |
| price | NUMERIC(18,2) |  | Yes |
| available | BOOLEAN |  | Yes |
- restaurant_id → restaurants.id
- Unique key: (restaurant_id, name).

## orders

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| restaurant_id | BIGINT | FK | Yes |
| client_order_key | TEXT | Unique | Yes |
| status | TEXT |  | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| delivery_address | TEXT |  | Yes |
- customer_id → customers.id
- restaurant_id → restaurants.id
- Unique key: (client_order_key).

## order_items

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| menu_item_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → orders.id
- menu_item_id → menu_items.id
- Unique key: (order_id, menu_item_id).

## Relationships and business rules

- Each restaurant slug is required and unique.
- Each customer email is required and unique.
- menu_items.restaurant_id references restaurants.id.
- A restaurant cannot have two menu items with the same name.
- Menu item price must be greater than zero.
- orders.customer_id references customers.id.
- orders.restaurant_id references restaurants.id.
- Each client order key is unique, allowing duplicate submissions to be detected safely.
- Order status must be pending, accepted, preparing, delivered, or cancelled.
- order_items.order_id references orders.id.
- order_items.menu_item_id references menu_items.id.
- Each order-item quantity must be greater than zero.
- Each recorded order-item unit price must be greater than zero.

## Assumptions

- Each entity has a single-column UUID primary key generated from one global namespace, so IDs are unique across tables.
- Each order belongs to one customer and one restaurant; each menu item belongs to one restaurant.
- An order-item unit_price records the menu price when the order is placed; prices use one assumed currency.
- Order status is pending, accepted, preparing, delivered, or cancelled.
- Dates and all sample records used in exercises are synthetic.

