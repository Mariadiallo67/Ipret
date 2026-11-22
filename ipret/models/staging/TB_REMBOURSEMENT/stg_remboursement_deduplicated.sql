{{ config(materialized='view') }}

with prepared_remboursement as
(
    select
        try_to_number(nullif(trim(id_remboursement), ''))                                 as id_remboursement,
        replace(replace(nullif(trim(dt_remboursement), ''), '.', '/'), '-', '/')          as dt_remboursement_raw,
        try_to_decimal(replace(regexp_replace(mt_rembourse, '[^0-9,.]', ''), ',', '.'), 12, 2)     as mt_rembourse,
        try_to_decimal(replace(regexp_replace(mt_capital_paye, '[^0-9,.]', ''), ',', '.'), 12, 2)  as mt_capital_paye,
        try_to_decimal(replace(regexp_replace(mt_interet_paye, '[^0-9,.]', ''), ',', '.'), 12, 2)  as mt_interet_paye,
        nullif(upper(trim(cd_mode_remboursement)), '')                                    as cd_mode_remboursement,
        try_to_number(nullif(trim(id_pret), ''))                                          as id_pret
    from {{ source('bronze', 'TB_REMBOURSEMENT') }}
),

cleaned_remboursement as
(
    select
        * exclude (dt_remboursement_raw),
        case
            when regexp_like(dt_remboursement_raw, '\\d{4}/\\d{2}/\\d{2}') then try_to_date(dt_remboursement_raw, 'YYYY/MM/DD')
            when regexp_like(dt_remboursement_raw, '\\d{2}/\\d{2}/\\d{4}') then try_to_date(dt_remboursement_raw, 'DD/MM/YYYY')
            when regexp_like(dt_remboursement_raw, '\\d{2}/\\d{2}/\\d{2}')   then try_to_date(dt_remboursement_raw, 'DD/MM/YY')
        end as dt_remboursement
    from prepared_remboursement
)

select
    *,
    row_number() over (
        partition by id_remboursement
        order by dt_remboursement, id_pret
    ) as rn,
    case
        when id_remboursement is null                       then 'missing remboursement id'
        when rn > 1                                         then 'duplicate key'
        when dt_remboursement is null                       then 'missing or invalid remboursement date'
        when dt_remboursement > current_date()              then 'remboursement date in the future'
        when mt_rembourse is null or mt_rembourse <= 0      then 'missing or invalid montant rembourse'
        when mt_capital_paye is null or mt_capital_paye < 0 then 'missing or invalid montant capital'
        when mt_interet_paye is null or mt_interet_paye < 0 then 'missing or invalid montant interet'
        when abs(mt_capital_paye + mt_interet_paye - mt_rembourse) > 0.01
                                                            then 'capital + interet differ from montant rembourse'
        when cd_mode_remboursement is null                  then 'missing mode remboursement code'
        when id_pret is null                                then 'missing pret id'
    end as rejected_reason
from cleaned_remboursement