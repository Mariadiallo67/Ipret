{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_periodicite_remboursement', 'lb_periodicite_remboursement', 'rn'])}} as rejection_id,
            cd_periodicite_remboursement, lb_periodicite_remboursement,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_periodicite_remboursement is null  then 'missing type pret code'
            when lb_periodicite_remboursement is null then 'missing type pret description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_periodicite_remboursement_deduplicated')}}
where rn > 1
    or cd_periodicite_remboursement is null
    or lb_periodicite_remboursement is null