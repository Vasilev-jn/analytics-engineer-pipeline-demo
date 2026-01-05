-- Check 1: sums match
select
  (select round(sum(amount), 2) from stg_transactions) as stg_sum,
  (select round(sum(spend_amount), 2) from mart_spend_by_category_month) as mart_sum,
  (select round((select sum(amount) from stg_transactions) - (select sum(spend_amount) from mart_spend_by_category_month), 2)) as diff;

-- Check 2: no bad values in staging
select
  sum(case when tx_date is null then 1 else 0 end) as null_dates,
  sum(case when category is null or category = '' then 1 else 0 end) as bad_category,
  sum(case when amount is null or amount <= 0 then 1 else 0 end) as bad_amount
from stg_transactions;
