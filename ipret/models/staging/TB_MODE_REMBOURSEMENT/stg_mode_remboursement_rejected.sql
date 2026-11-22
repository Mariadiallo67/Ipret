{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_mode_remboursement', 'lb_mode_remboursement', 'rn'])}} as rejection_id,
            cd_mode_remboursement, lb_mode_remboursement,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_mode_remboursement is null  then 'missing type pret code'
            when lb_mode_remboursement is null then 'missing type pret description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_mode_remboursement_deduplicated')}}
where rn > 1
    or cd_mode_remboursement is null
    or lb_mode_remboursement is null