with cleaned_TB_MODE_REMBOURSEMENT as
(
    select nullif(trim(cd_mode_remboursement),'')  as cd_mode_remboursement,
        nullif(trim(regexp_replace(initcap(lb_mode_remboursement), '\\s+', ' ')),'')  as lb_mode_remboursement
     from {{source('bronze', 'TB_MODE_REMBOURSEMENT')}}
)

SELECT *, 
        row_number() over(
            partition by cd_mode_remboursement 
            order by lb_mode_remboursement) as rn
FROM cleaned_TB_MODE_REMBOURSEMENT