select
    row_number() over (order by cd_type_pret) as id_dim_type_pret,
    cd_type_pret,
    lb_type_pret
from {{ ref('stg_type_pret') }}