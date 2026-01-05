from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.types import BigInteger, Date, Numeric, Text


def env(name: str, default: str) -> str:
    v = os.getenv(name)
    return v if v else default


PG_HOST = env("PG_HOST", "127.0.0.1")
PG_PORT = env("PG_PORT", "5433")
PG_DB = env("PG_DB", "ae_db")
PG_USER = env("PG_USER", "ae_user")
PG_PASS = env("PG_PASS", "ae_pass")

RAW_CSV = Path("data") / "raw" / "transactions.csv"


def main() -> None:
    if not RAW_CSV.exists():
        raise FileNotFoundError(f"Raw CSV not found: {RAW_CSV}")

    print(f"DEBUG conn {PG_HOST}:{PG_PORT} db={PG_DB} user={PG_USER}")

    df = pd.read_csv(RAW_CSV)
    df["tx_date"] = pd.to_datetime(df["tx_date"], errors="coerce").dt.date

    engine = create_engine(
        f"postgresql+psycopg2://{PG_USER}:{PG_PASS}@{PG_HOST}:{PG_PORT}/{PG_DB}",
        pool_pre_ping=True,
    )

    dtype = {
        "tx_id": BigInteger(),
        "tx_date": Date(),
        "amount": Numeric(12, 2),
        "category": Text(),
        "source": Text(),
    }

    with engine.begin() as conn:
        # replace makes the run idempotent: table content is fully refreshed
        df.to_sql("raw_transactions", conn, if_exists="replace", index=False, dtype=dtype)

        cnt = conn.execute(text("select count(*) from raw_transactions")).scalar_one()
        print(f"OK: loaded raw_transactions rows={cnt}")


if __name__ == "__main__":
    main()
