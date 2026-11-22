{{  
    config(  
       materialized='incremental',  
       unique_key='rejection_id'  
    )
}} 

select {{dbt_utils.generate_surrogate_key(['cd_type_pret', 'lb_type_pret', 'rn'])}} as rejection_id,
            cd_type_pret, lb_type_pret,
        convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
        case
            when cd_type_pret is null  then 'missing type pret code'
            when lb_type_pret is null then 'missing type pret description'
            when rn > 1               then  'deduplicate key'
        end as rejected_reason    
from {{ref ('stg_type_pret_deduplicated')}}
where rn > 1
    or cd_type_pret is null
    or lb_type_pret is null