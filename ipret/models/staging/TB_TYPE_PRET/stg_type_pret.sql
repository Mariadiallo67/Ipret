select cd_type_pret, lb_type_pret 
from {{ref('stg_type_pret_deduplicated')}}
where rn = 1
    and cd_type_pret is not null
    and lb_type_pret is not null