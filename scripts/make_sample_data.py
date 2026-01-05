from __future__ import annotations

import random
from datetime import datetime, timedelta
import csv
from pathlib import Path

def main() -> None:
    out = Path("data/raw/transactions.csv")
    out.parent.mkdir(parents=True, exist_ok=True)

    categories = ["food", "transport", "home", "health", "fun", "education", "subscriptions"]
    sources = ["tinkoff", "alfa", "cash"]

    start = datetime(2025, 7, 1)
    rows = []
    for i in range(1200):
        dt = start + timedelta(days=random.randint(0, 185))
        amount = round(random.uniform(50, 5000), 2)
        cat = random.choice(categories)
        src = random.choice(sources)
        rows.append([i + 1, dt.date().isoformat(), amount, cat, src])

    with out.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["tx_id", "tx_date", "amount", "category", "source"])
        w.writerows(rows)

    print(f"OK: wrote {len(rows)} rows to {out}")

if __name__ == "__main__":
    main()
