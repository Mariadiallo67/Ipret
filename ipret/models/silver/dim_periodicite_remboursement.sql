select
    row_number() over (order by cd_periodicite_remboursement) as id_dim_periodicite_remboursement,
    cd_periodicite_remboursement,
    lb_periodicite_remboursement
from {{ ref('stg_periodicite_remboursement') }}