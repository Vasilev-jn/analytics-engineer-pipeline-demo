from __future__ import annotations

import os
from pathlib import Path
from datetime import datetime, timedelta
import numpy as np
import pandas as pd


def main() -> None:
    np.random.seed(42)

    rows = int(os.getenv("ROWS", "1200"))
    out_path = Path("data") / "raw" / "transactions.csv"
    out_path.parent.mkdir(parents=True, exist_ok=True)

    categories = ["food", "transport", "home", "health", "education", "fun", "subscriptions"]
    sources = ["bank_a", "bank_b", "cash"]

    start_date = datetime(2025, 10, 1)
    days_range = 120

    tx_id = np.arange(1, rows + 1, dtype=np.int64)
    tx_date = [start_date + timedelta(days=int(x)) for x in np.random.randint(0, days_range, size=rows)]
    amount = np.round(np.random.lognormal(mean=7.5, sigma=0.6, size=rows), 2)

    df = pd.DataFrame(
        {
            "tx_id": tx_id,
            "tx_date": pd.to_datetime(tx_date).dt.date,
            "amount": amount,
            "category": np.random.choice(categories, size=rows),
            "source": np.random.choice(sources, size=rows),
        }
    )

    df.to_csv(out_path, index=False, encoding="utf-8")
    print(f"OK: wrote {len(df)} rows to {out_path.as_posix()}")


if __name__ == "__main__":
    main()
