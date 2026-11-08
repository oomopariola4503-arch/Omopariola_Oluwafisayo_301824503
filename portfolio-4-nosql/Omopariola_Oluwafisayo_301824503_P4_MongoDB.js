// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("order_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("order_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "order_placed",
                    "order_accepted"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "order_items"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("order_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_placed",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "order_items",
            "key": {
                "id": 501
            },
            "snapshot": {
                "id": 501,
                "order_id": 401,
                "menu_item_id": 301,
                "quantity": 2,
                "unit_price": 12.5
            }
        },
        "embedded": {
            "menu_items": [
                {
                    "key": {
                        "id": 301
                    },
                    "snapshot": {
                        "id": 301,
                        "restaurant_id": 101,
                        "name": "Garden Bowl",
                        "price": 12.5,
                        "available": true
                    },
                    "via": [
                        "order_items.menu_item_id → menu_items"
                    ]
                }
            ]
        },
        "references": {
            "orders": [
                {
                    "key": {
                        "id": 401
                    },
                    "via": [
                        "order_items.order_id → orders"
                    ]
                }
            ],
            "customers": [
                {
                    "key": {
                        "id": 201
                    },
                    "via": [
                        "order_items.order_id → orders.customer_id → customers"
                    ]
                }
            ],
            "restaurants": [
                {
                    "key": {
                        "id": 101
                    },
                    "via": [
                        "order_items.order_id → orders.restaurant_id → restaurants",
                        "order_items.menu_item_id → menu_items.restaurant_id → restaurants"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_accepted",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "order_items",
            "key": {
                "id": 501
            },
            "snapshot": {
                "id": 501,
                "order_id": 401,
                "menu_item_id": 301,
                "quantity": 2,
                "unit_price": 12.5
            }
        },
        "embedded": {
            "menu_items": [
                {
                    "key": {
                        "id": 301
                    },
                    "snapshot": {
                        "id": 301,
                        "restaurant_id": 101,
                        "name": "Garden Bowl",
                        "price": 12.5,
                        "available": true
                    },
                    "via": [
                        "order_items.menu_item_id → menu_items"
                    ]
                }
            ]
        },
        "references": {
            "orders": [
                {
                    "key": {
                        "id": 401
                    },
                    "via": [
                        "order_items.order_id → orders"
                    ]
                }
            ],
            "customers": [
                {
                    "key": {
                        "id": 201
                    },
                    "via": [
                        "order_items.order_id → orders.customer_id → customers"
                    ]
                }
            ],
            "restaurants": [
                {
                    "key": {
                        "id": 101
                    },
                    "via": [
                        "order_items.order_id → orders.restaurant_id → restaurants",
                        "order_items.menu_item_id → menu_items.restaurant_id → restaurants"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "delivery_instructions": "illustrative delivery_instructions",
                "promotion_metadata": "illustrative promotion_metadata",
                "substitution_details": "illustrative substitution_details",
                "courier_location": "illustrative courier_location"
            }
        }
    }
]));
  await db.getCollection("order_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("order_events").find({"source.key.id":501}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("order_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_items",
        "key": {
            "id": 501
        },
        "snapshot": {
            "id": 501,
            "order_id": 401,
            "menu_item_id": 301,
            "quantity": 2,
            "unit_price": 12.5
        }
    },
    "embedded": {
        "menu_items": [
            {
                "key": {
                    "id": 301
                },
                "snapshot": {
                    "id": 301,
                    "restaurant_id": 101,
                    "name": "Garden Bowl",
                    "price": 12.5,
                    "available": true
                },
                "via": [
                    "order_items.menu_item_id → menu_items"
                ]
            }
        ]
    },
    "references": {
        "orders": [
            {
                "key": {
                    "id": 401
                },
                "via": [
                    "order_items.order_id → orders"
                ]
            }
        ],
        "customers": [
            {
                "key": {
                    "id": 201
                },
                "via": [
                    "order_items.order_id → orders.customer_id → customers"
                ]
            }
        ],
        "restaurants": [
            {
                "key": {
                    "id": 101
                },
                "via": [
                    "order_items.order_id → orders.restaurant_id → restaurants",
                    "order_items.menu_item_id → menu_items.restaurant_id → restaurants"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("order_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_items",
        "key": {
            "id": 501
        },
        "snapshot": {
            "id": 501,
            "order_id": 401,
            "menu_item_id": 301,
            "quantity": 2,
            "unit_price": 12.5
        }
    },
    "embedded": {
        "menu_items": [
            {
                "key": {
                    "id": 301
                },
                "snapshot": {
                    "id": 301,
                    "restaurant_id": 101,
                    "name": "Garden Bowl",
                    "price": 12.5,
                    "available": true
                },
                "via": [
                    "order_items.menu_item_id → menu_items"
                ]
            }
        ]
    },
    "references": {
        "orders": [
            {
                "key": {
                    "id": 401
                },
                "via": [
                    "order_items.order_id → orders"
                ]
            }
        ],
        "customers": [
            {
                "key": {
                    "id": 201
                },
                "via": [
                    "order_items.order_id → orders.customer_id → customers"
                ]
            }
        ],
        "restaurants": [
            {
                "key": {
                    "id": 101
                },
                "via": [
                    "order_items.order_id → orders.restaurant_id → restaurants",
                    "order_items.menu_item_id → menu_items.restaurant_id → restaurants"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("order_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
