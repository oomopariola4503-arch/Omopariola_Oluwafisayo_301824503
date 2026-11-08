# Portfolio 1 — Database Design and Modelling

I organised the data into restaurants, customers, menu_items, orders, order_items. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| restaurants | 1 |
| customers | 1 |
| menu_items | 1 |
| orders | 1 |
| order_items | 1 |

The 20 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Omopariola_Oluwafisayo_301824503_P1_Design.md)
- [ER diagram](Omopariola_Oluwafisayo_301824503_P1_ERDiagram.md)
- [Normalisation](Omopariola_Oluwafisayo_301824503_P1_Normalisation.md)
- [Schema](Omopariola_Oluwafisayo_301824503_P1_Schema.sql)
- [Sample data](Omopariola_Oluwafisayo_301824503_P1_SampleData.sql)
- [Constraint tests](Omopariola_Oluwafisayo_301824503_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Omopariola_Oluwafisayo_301824503_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

