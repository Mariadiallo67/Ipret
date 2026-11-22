{{ config(materialized='table') }}

select
    id_pret,
    dt_pret,
    mt_pret,
    nb_duree_remboursement,
    tx_interet_pret,
    cd_type_pret,
    id_emprunteur,
    cd_statut_pret,
    cd_periodicite_remboursement,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
    rejected_reason
from {{ ref('stg_pret_deduplicated') }}
where rejected_reason is not null