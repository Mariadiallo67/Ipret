{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_statut_emprunteur', 'lb_statut_emprunteur', 'rn'])}} as rejection_id,
            cd_statut_emprunteur, lb_statut_emprunteur,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_statut_emprunteur is null  then 'missing statut emprunteur code'
            when lb_statut_emprunteur is null then 'missing statut emprunteur description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_statut_emprunteur_deduplicated')}}
where rn > 1
    and cd_statut_emprunteur is not null
    and lb_statut_emprunteur is not null