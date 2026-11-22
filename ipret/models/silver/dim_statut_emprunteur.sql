select
    row_number() over (order by cd_statut_emprunteur) as id_dim_statut_emprunteur,
    cd_statut_emprunteur,
    lb_statut_emprunteur
from {{ ref('stg_statut_emprunteur') }}