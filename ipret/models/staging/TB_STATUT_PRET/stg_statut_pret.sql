select cd_statut_pret, lb_statut_pret 
from {{ref('stg_statut_pret_deduplicated')}}
where rn = 1
    and cd_statut_pret is not null
    and lb_statut_pret is not null