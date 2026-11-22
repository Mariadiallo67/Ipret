{{ config(materialized='table') }}

select
    id_remboursement,
    dt_remboursement,
    mt_rembourse,
    mt_capital_paye,
    mt_interet_paye,
    cd_mode_remboursement,
    id_pret,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
    rejected_reason
from {{ ref('stg_remboursement_deduplicated') }}
where rejected_reason is not null