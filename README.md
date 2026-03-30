# dbt-contracts-demo

Hands-on demo project for a presentation on [dbt contracts](https://docs.getdbt.com/docs/collaborate/govern/model-contracts).

Covers three features:
1. **Model contracts** — enforce column names and data types at run time
2. **Constraints** — declare `not_null`, `unique`, `primary_key` on columns
3. **Model versioning** — ship breaking changes safely with `v1` / `v2`

Stack: DuckDB via `dbt-duckdb`, no external services needed.

## Setup

**1. Install dependencies**

```bash
uv sync
```

**2. Add the dbt profile**

dbt looks for `profiles.yml` in `~/.dbt/` by default. Copy the profile from this repo there:

```bash
mkdir -p ~/.dbt
cp profiles.yml ~/.dbt/profiles.yml
```

If you already have a `~/.dbt/profiles.yml` with other profiles, append the `dbt_contracts_demo` block from `profiles.yml` to it instead of overwriting.

**3. Verify connectivity**

```bash
uv run dbt debug
```

## Run the demo

See [DEMO_SCRIPT.md](./DEMO_SCRIPT.md) for the full step-by-step presenter guide.

```bash
uv run dbt build
```
