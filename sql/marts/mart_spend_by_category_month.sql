drop table if exists mart_spend_by_category_month;

create table mart_spend_by_category_month as
with agg as (
  select
    date_trunc('month', tx_date)::date as month,
    category,
    sum(amount) as spend_amount,
    count(*) as tx_count
  from stg_transactions
  group by 1, 2
),
ranked as (
  select
    *,
    row_number() over (partition by month order by spend_amount desc) as rn
  from agg
)
select
  month,
  category,
  spend_amount,
  tx_count
from ranked
where rn <= 10
order by month, spend_amount desc;

select count(*) from mart_spend_by_category_month;
