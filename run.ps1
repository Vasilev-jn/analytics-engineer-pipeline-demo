$ErrorActionPreference = "Stop"

$env:PG_HOST="127.0.0.1"
$env:PG_PORT="5433"
$env:PG_DB="ae_db"
$env:PG_USER="ae_user"
$env:PG_PASS="ae_pass"

python scripts\make_sample_data.py
python scripts\load_raw_to_postgres.py

Get-Content .\sql\staging\stg_transactions.sql | docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1
Get-Content .\sql\marts\mart_spend_by_category_month.sql | docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1
Get-Content .\sql\checks\data_quality.sql | docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1

docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -c "select * from mart_spend_by_category_month order by month desc, spend_amount desc limit 10;"
