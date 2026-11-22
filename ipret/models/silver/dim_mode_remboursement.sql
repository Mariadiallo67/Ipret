select
    row_number() over (order by cd_mode_remboursement) as id_dim_mode_remboursement,
    cd_mode_remboursement,
    lb_mode_remboursement
from {{ ref('stg_mode_remboursement') }}