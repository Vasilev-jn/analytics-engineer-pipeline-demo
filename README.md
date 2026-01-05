# Analytics Engineer Pipeline Demo

Мини-проект: демонстрация пайплайна подготовки данных для отчетности.

## What it does
- Генерирует пример транзакций в CSV (raw layer)
- Загружает raw в PostgreSQL (Python)
- Строит staging слой (SQL)
- Строит витрину: расходы по категориям по месяцам, top-10 (SQL)
- Запускает проверки качества данных (SQL)

## Tech stack
- Python: pandas, SQLAlchemy, psycopg2
- PostgreSQL (Docker)
- SQL (staging, marts)
- PowerShell run script

## How to run
1) Start Postgres:
```powershell
docker compose up -d
