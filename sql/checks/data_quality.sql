-- Check 1: sums must match (diff = 0.00)
select
  (select round(sum(amount), 2) from stg_transactions) as stg_sum,
  (select round(sum(spend_amount), 2) from mart_spend_by_category_month) as mart_sum,
  (select round((select sum(amount) from stg_transactions) - (select sum(spend_amount) from mart_spend_by_category_month), 2)) as diff;

-- Check 2: no bad values in staging (all must be 0)
select
  sum(case when tx_date is null then 1 else 0 end) as null_dates,
  sum(case when category is null or category = '' then 1 else 0 end) as bad_category,
  sum(case when amount is null or amount <= 0 then 1 else 0 end) as bad_amount
from stg_transactions;

-- Check 3: row counts
select
  (select count(*) from raw_transactions) as raw_count,
  (select count(*) from stg_transactions) as stg_count,
  (select count(*) from mart_spend_by_category_month) as mart_count;
