# Food Delivery / Restaurant Ordering System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| restaurant_id | menu_items records (list) |
| --- | --- |
| 101 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| menu_items.id | menu_items.restaurant_id | menu_items.name | restaurants.id | restaurants.name |
| --- | --- | --- | --- | --- |
| 301 | 101 | Garden Bowl | 101 | Maple Table |

Key: id.

## 2NF: depend on the whole key

menu_items: restaurant_id is a proper part of candidate key (restaurant_id, name), and determines restaurants details.

## restaurants_example

| restaurants.id | restaurants.name |
| --- | --- |
| 101 | Maple Table |

## menu_items_example

| menu_items.id | menu_items.restaurant_id | menu_items.name |
| --- | --- | --- |
| 301 | 101 | Garden Bowl |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## restaurants

| id | name | slug | address | active |
| --- | --- | --- | --- | --- |
| 101 | Maple Table | maple-table | 12 Cedar Lane, Sampleton | true |

## customers

| id | full_name | email | phone |
| --- | --- | --- | --- |
| 201 | Alex Rivera | alex.rivera@example.test | +1-555-0101 |

## menu_items

| id | restaurant_id | name | price | available |
| --- | --- | --- | --- | --- |
| 301 | 101 | Garden Bowl | 12.5 | true |

## orders

| id | customer_id | restaurant_id | client_order_key | status | placed_at | delivery_address |
| --- | --- | --- | --- | --- | --- | --- |
| 401 | 201 | 101 | client-order-001 | accepted | 2026-10-12T18:30:00+00:00 | 45 Birch Street, Sampleton |

## order_items

| id | order_id | menu_item_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 501 | 401 | 301 | 2 | 12.5 |

## Dependencies

- restaurants: (id) → name, slug, address, active
- customers: (id) → full_name, email, phone
- menu_items: (id) → restaurant_id, name, price, available
- orders: (id) → customer_id, restaurant_id, client_order_key, status, placed_at, delivery_address
- order_items: (id) → order_id, menu_item_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
