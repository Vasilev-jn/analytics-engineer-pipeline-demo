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
)
select *
from base
where amount is not null
  and amount > 0
  and tx_date is not null;
