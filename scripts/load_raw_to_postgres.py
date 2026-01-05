from __future__ import annotations

import os
import pandas as pd
from sqlalchemy import create_engine, text

PG_HOST = os.getenv("PG_HOST", "localhost")
PG_PORT = os.getenv("PG_PORT", "5432")
PG_DB = os.getenv("PG_DB", "ae_db")
PG_USER = os.getenv("PG_USER", "ae_user")
PG_PASS = os.getenv("PG_PASS", "ae_pass")

RAW_CSV = "data/raw/transactions.csv"

def main() -> None:
    print("DEBUG", PG_HOST, PG_PORT, PG_DB, PG_USER, PG_PASS)
    engine = create_engine(
        f"postgresql+psycopg2://{PG_USER}:{PG_PASS}@{PG_HOST}:{PG_PORT}/{PG_DB}"
    )

    df = pd.read_csv(RAW_CSV)

    with engine.begin() as conn:
        conn.execute(text("drop table if exists raw_transactions"))
    df.to_sql("raw_transactions", engine, if_exists="replace", index=False)

    with engine.begin() as conn:
        cnt = conn.execute(text("select count(*) from raw_transactions")).scalar_one()
    print(f"OK: loaded raw_transactions rows={cnt}")

if __name__ == "__main__":
    main()
