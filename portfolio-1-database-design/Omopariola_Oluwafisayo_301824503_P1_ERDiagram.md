# Food Delivery / Restaurant Ordering System — ER diagram

```mermaid
erDiagram
    direction LR
    restaurants {
        bigint id PK
        text name
        text slug UK
        text address
        boolean active
    }
    customers {
        bigint id PK
        text full_name
        text email UK
        text phone "Optional"
    }
    menu_items {
        bigint id PK
        bigint restaurant_id FK
        text name
        numeric price
        boolean available
    }
    orders {
        bigint id PK
        bigint customer_id FK
        bigint restaurant_id FK
        text client_order_key UK
        text status
        timestamptz placed_at
        text delivery_address
    }
    order_items {
        bigint id PK
        bigint order_id FK
        bigint menu_item_id FK
        integer quantity
        numeric unit_price
    }
    restaurants ||--o{ menu_items : "restaurant_id"
    customers ||--o{ orders : "customer_id"
    restaurants ||--o{ orders : "restaurant_id"
    orders ||--o{ order_items : "order_id"
    menu_items ||--o{ order_items : "menu_item_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Omopariola_Oluwafisayo_301824503_ERDiagram.png)
