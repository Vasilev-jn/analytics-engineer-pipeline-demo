# Analytics Engineer Pipeline Demo

Мини-проект: воспроизводимый пайплайн подготовки данных для отчетности.

## What it does
- Генерирует пример транзакций в CSV (raw)
- Загружает raw в PostgreSQL (Python)
- Строит staging слой (SQL)
- Строит витрину расходов по категориям по месяцам, top 10 (SQL)
- Запускает проверки качества данных (SQL)

## Tech stack
- Python (pandas, SQLAlchemy, psycopg2)
- PostgreSQL (Docker)
- SQL (staging, marts, checks)
- PowerShell (one-command runner)

## Prerequisites
- Docker Desktop
- Python 3.10+

## How to run
1) Install Python dependencies
```powershell
pip install -r requirements.txt


Start Postgres

docker compose up -d


Postgres доступен на 127.0.0.1:5433

Run pipeline end-to-end (includes staging, mart, and checks)

powershell -ExecutionPolicy Bypass -File .\run.ps1

Project structure

scripts - генерация данных и загрузка raw

sql/staging - чистка и нормализация

sql/marts - витрина

sql/checks - проверки качества

run.ps1 - запуск одной командой

Data quality checks

Pass criteria:

diff = 0.00 (суммы в staging и mart совпадают)

bad_amount = 0, bad_category = 0, null_dates = 0


---
