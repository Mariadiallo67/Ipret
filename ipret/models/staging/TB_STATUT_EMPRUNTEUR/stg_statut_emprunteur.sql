select cd_statut_emprunteur, lb_statut_emprunteur 
from {{ref('stg_statut_emprunteur_deduplicated')}}
where rn = 1
    and cd_statut_emprunteur is not null
    and lb_statut_emprunteur is not null