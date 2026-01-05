$ErrorActionPreference = "Stop"

Write-Host "Step 1: Start Postgres (docker compose up -d)"
docker compose up -d | Out-Host

Write-Host "Step 2: Wait for Postgres to be ready"
$maxRetries = 30
$ready = $false

for ($i = 1; $i -le $maxRetries; $i++) {
  docker exec ae_demo_postgres pg_isready -U ae_user -d ae_db -h 127.0.0.1 -p 5432 | Out-Null
  if ($LASTEXITCODE -eq 0) {
    $ready = $true
    break
  }
  Start-Sleep -Seconds 2
}

if (-not $ready) {
  throw "Postgres did not become ready in time. Check: docker logs ae_demo_postgres --tail 50"
}

Write-Host "Postgres is ready"

Write-Host "Step 3: Set env vars for Python connection"
$env:PG_HOST = "127.0.0.1"
$env:PG_PORT = "5433"
$env:PG_DB   = "ae_db"
$env:PG_USER = "ae_user"
$env:PG_PASS = "ae_pass"
$env:ROWS    = "1200"

Write-Host "Step 4: Generate sample data"
python scripts\make_sample_data.py | Out-Host

Write-Host "Step 5: Load raw to Postgres"
python scripts\load_raw_to_postgres.py | Out-Host

Write-Host "Step 6: Build staging"
Get-Content .\sql\staging\stg_transactions.sql |
  docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1 | Out-Host

Write-Host "Step 7: Build mart"
Get-Content .\sql\marts\mart_spend_by_category_month.sql |
  docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1 | Out-Host

Write-Host "Step 8: Run data quality checks"
Get-Content .\sql\checks\data_quality.sql |
  docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -v ON_ERROR_STOP=1 | Out-Host

Write-Host "Step 9: Show sample of mart"
docker exec -i ae_demo_postgres psql -U ae_user -d ae_db -c `
"select * from mart_spend_by_category_month order by month desc, spend_amount desc limit 10;" | Out-Host

Write-Host "Done"
