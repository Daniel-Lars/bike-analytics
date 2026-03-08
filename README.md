**Follow these steps to start the project locally.**

## 📂 Input Data

This project requires source data files placed in the `data/` directory.

The data itself is **not committed to GitHub**.

### Folder structure

Expected folder structure for data:

project-root/
├── data/
│   ├── contracts/
│   │   └── contracts.csv
│   ├── usage/
│   │   └── bike_usage.csv
│   └── customers/
│       └── customer.csv


## 1. Install dependencies

```bash
uv sync
```
## 2. Environment Variables
Create .env file and set environemnt variables:

    DEV_POSTGRES_USER=<your_postgres_user_here>
    DEV_POSTGRES_PASSWORD=<your_super_safe_password_here>
    DEV_POSTGRES_DB=<your_db_name_here>
    DEVELOPER_SCHEMA_PREFIX=<your_developer_name_here>

## 3. Start Infrastructure
```bash
docker compose up -d
```

## 4. Ready to use dbt
Cd into the dbt_project folder and interact with the database. dbt --target dev will prefix schemas with the provided `DEVELOPER_SCHEMA_PREFIX`.
```bash
cd dbt_project
dbt build
dbt build --target prod  -> builds the dbt models in a common schema
```

## 5. Take down Infrastructure
```bash
docker compose down -v
```
