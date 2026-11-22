select
    row_number() over (order by cd_type_emprunteur) as id_dim_type_emprunteur,
    cd_type_emprunteur,
    lb_type_emprunteur
from {{ ref('stg_type_emprunteur') }}