drop table if exists stg_transactions;

create table stg_transactions as
with base as (
  select
    cast(tx_id as bigint) as tx_id,
    cast(tx_date as date) as tx_date,
    cast(amount as numeric(12,2)) as amount,
    lower(trim(category)) as category,
    lower(trim(source)) as source
  from raw_transactions
),
dedup as (
  select
    *,
    row_number() over (partition by tx_id order by tx_date desc) as rn
  from base
)
select
  tx_id,
  tx_date,
  amount,
  category,
  source
from dedup
where rn = 1
  and tx_date is not null
  and category is not null
  and category <> ''
  and amount is not null
  and amount > 0;

select count(*) from stg_transactions;
