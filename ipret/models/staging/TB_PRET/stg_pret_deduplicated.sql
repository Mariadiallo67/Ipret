{{ config(materialized='view') }}

with prepared_pret as
(
    select
        try_to_number(nullif(trim(id_pret), ''))                                       as id_pret,
        replace(replace(nullif(trim(dt_pret), ''), '.', '/'), '-', '/')                as dt_pret_raw,
        try_to_decimal(replace(regexp_replace(mt_pret, '[^0-9,.]', ''), ',', '.'), 12, 2) as mt_pret,
        try_to_number(nullif(trim(nb_duree_remboursement), ''))                        as nb_duree_remboursement,
        try_to_decimal(replace(regexp_replace(tx_interet_pret, '[^0-9,.]', ''), ',', '.'), 5, 2) as tx_interet_pret,
        nullif(upper(trim(cd_type_pret)), '')                                          as cd_type_pret,
        try_to_number(nullif(trim(id_emprunteur), ''))                                 as id_emprunteur,
        nullif(upper(trim(cd_statut_pret)), '')                                        as cd_statut_pret,
        nullif(upper(trim(cd_periodicite_remboursement)), '')                          as cd_periodicite_remboursement
    from {{ source('bronze', 'TB_PRET') }}
),

cleaned_pret as
(
    select
        * exclude (dt_pret_raw),
        case
            when regexp_like(dt_pret_raw, '\\d{4}/\\d{2}/\\d{2}') then try_to_date(dt_pret_raw, 'YYYY/MM/DD')
            when regexp_like(dt_pret_raw, '\\d{2}/\\d{2}/\\d{4}') then try_to_date(dt_pret_raw, 'DD/MM/YYYY')
            when regexp_like(dt_pret_raw, '\\d{2}/\\d{2}/\\d{2}')   then try_to_date(dt_pret_raw, 'DD/MM/YY')
        end as dt_pret
    from prepared_pret
)

select
    *,
    row_number() over (
        partition by id_pret
        order by dt_pret, id_emprunteur
    ) as rn,
    case
        when id_pret is null                            then 'missing pret id'
        when rn > 1                                     then 'duplicate key'
        when dt_pret is null                            then 'missing or invalid pret date'
        when dt_pret > current_date()                   then 'pret date in the future'
        when mt_pret is null or mt_pret <= 0            then 'missing or invalid montant'
        when nb_duree_remboursement is null
          or nb_duree_remboursement <= 0                then 'missing or invalid duree'
        when tx_interet_pret is null or tx_interet_pret < 0 then 'missing or invalid taux'
        when cd_type_pret is null                       then 'missing type pret code'
        when id_emprunteur is null                      then 'missing emprunteur id'
        when cd_statut_pret is null                     then 'missing statut pret code'
        when cd_periodicite_remboursement is null       then 'missing periodicite code'
    end as rejected_reason
from cleaned_pret