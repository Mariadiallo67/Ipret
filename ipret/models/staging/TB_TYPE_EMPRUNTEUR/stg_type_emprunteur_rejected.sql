{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_type_emprunteur', 'lb_type_emprunteur', 'rn'])}} as rejection_id,
            cd_type_emprunteur, lb_type_emprunteur,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_type_emprunteur is null  then 'missing type emprunteur code'
            when lb_type_emprunteur is null then 'missing type emprunteur description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_type_emprunteur_deduplicated')}}
where rn > 1
    and cd_type_emprunteur is not null
    and lb_type_emprunteur is not null