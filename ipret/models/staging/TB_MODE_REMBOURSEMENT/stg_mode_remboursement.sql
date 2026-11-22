select cd_mode_remboursement, lb_mode_remboursement 
from {{ref('stg_mode_remboursement_deduplicated')}}
where rn = 1
    and cd_mode_remboursement is not null
    and lb_mode_remboursement is not null