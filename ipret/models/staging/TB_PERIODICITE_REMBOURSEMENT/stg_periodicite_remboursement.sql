select cd_periodicite_remboursement, lb_periodicite_remboursement 
from {{ref('stg_periodicite_remboursement_deduplicated')}}
where rn = 1
    and cd_periodicite_remboursement is not null
    and lb_periodicite_remboursement is not null