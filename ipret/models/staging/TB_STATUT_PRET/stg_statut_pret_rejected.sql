{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_statut_pret', 'lb_statut_pret', 'rn'])}} as rejection_id,
            cd_statut_pret, lb_statut_pret,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_statut_pret is null  then 'missing statut pret code'
            when lb_statut_pret is null then 'missing statut pret description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_statut_pret_deduplicated')}}
where rn > 1
    or cd_statut_pret is null
    or lb_statut_pret is null