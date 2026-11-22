select cd_type_emprunteur, lb_type_emprunteur 
from {{ref('stg_type_emprunteur_deduplicated')}}
where rn = 1
    and cd_type_emprunteur is not null
    and lb_type_emprunteur is not null