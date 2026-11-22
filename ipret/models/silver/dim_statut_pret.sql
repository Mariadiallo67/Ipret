select
    row_number() over (order by cd_statut_pret) as id_dim_statut_pret,
    cd_statut_pret,
    lb_statut_pret
from {{ ref('stg_statut_pret') }}