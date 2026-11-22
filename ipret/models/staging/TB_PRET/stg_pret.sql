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
    cd_periodicite_remboursement
from {{ ref('stg_pret_deduplicated') }}
where rejected_reason is null