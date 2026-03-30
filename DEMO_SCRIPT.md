# dbt Contracts Demo — Presenter Script

## Setup

```bash
# Install dependencies
uv sync

# Verify connectivity
uv run dbt debug
```

---

## Step 0 — Load raw data

```bash
uv run dbt seed
```

Creates three tables in DuckDB:
- `raw_orders` (10 rows)
- `raw_customers` (6 rows)
- `raw_products` (5 rows)

---

## Step 1 — Run staging models (no contracts)

```bash
uv run dbt run --select staging
```

> **Talk track:** "These staging models have no contract. dbt runs them without
> any type checking. If someone accidentally changes a column type or name here,
> downstream models and BI tools will break at query time — silently, and only
> when someone actually runs a query. That's the problem contracts solve."

---

## Step 2 — Run mart models (contracts pass)

```bash
uv run dbt run --select marts
```

> **Talk track:** "The mart models have `contract: enforced: true`. dbt now
> compares the model's output columns against the declared schema before writing
> any data. Every column name and data type must match exactly."

Show the compiled DDL — notice explicit column types in the `CREATE TABLE`:

```bash
cat target/run/dbt_contracts_demo/models/marts/fct_orders_v2.sql
```

---

## Step 3 — Break the contract

In `models/marts/fct_orders_v2.sql`, change:
```sql
        o.order_id,
```
to:
```sql
        o.order_id as id,   -- renamed: breaks the contract
```

Then re-run:
```bash
uv run dbt run --select "fct_orders.v2"
```

**Expected error:**
```
This model has an enforced contract that failed.
Please ensure the name, data_type, and number of columns in your
contract match the columns in your model's definition.

| column_name | definition_type | contract_type | mismatch_reason     |
| id          | bigint          |               | missing in contract |
```

> **Talk track:** "dbt stops immediately and names exactly which contract was
> violated. You cannot ship a breaking change to downstream consumers without
> explicitly updating the contract. Revert the change before continuing."

Revert `o.order_id as id` back to `o.order_id`.

---

## Step 4 — Constraints

dbt lets you declare constraints alongside the contract. Show what the YAML
looks like:

```yaml
columns:
  - name: order_id
    data_type: bigint
    constraints:
      - type: not_null
  - name: amount
    data_type: decimal(10,2)
    constraints:
      - type: not_null
```

> **Talk track:** "Constraints sit right next to the column definitions — same
> place you already declared the name and type. On DuckDB these are enforced at
> write time: insert a NULL into `order_id` and the transaction fails with a
> hard error. No silent failures."

Show the compiled DDL — notice `NOT NULL` and `PRIMARY KEY` in the `CREATE TABLE`.

---

## Step 5 — Model versioning

Show that `ref('fct_orders')` resolves to v2:

```bash
uv run dbt compile --select analyses/demo_queries
cat target/compiled/dbt_contracts_demo/analyses/demo_queries.sql
```

Point out that `ref('fct_orders')` compiled to `fct_orders_v2` while
`ref('fct_orders', version=1)` compiled to `fct_orders_v1`.

> **Talk track:** "Both versions coexist. Consumers pinned to v1 keep working.
> New consumers get v2 by default via `latest_version: 2` in the YAML.
> This is how you ship breaking changes in a data warehouse without a big-bang
> cutover — the contract makes the change explicit and the version makes it safe."

---

## Full build

```bash
uv run dbt build
```

Runs seed → run → test for all nodes in dependency order. All green.
