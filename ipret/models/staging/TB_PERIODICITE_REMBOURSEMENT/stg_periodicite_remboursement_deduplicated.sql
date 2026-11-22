with cleaned_TB_PERIODICITE_REMBOURSEMENT as
(
    select nullif(trim(cd_periodicite_remboursement),'')  as cd_periodicite_remboursement,
        nullif(trim(regexp_replace(initcap(lb_periodicite_remboursement), '\\s+', ' ')),'')  as lb_periodicite_remboursement
     from {{source('bronze', 'TB_PERIODICITE_REMBOURSEMENT')}}
)

SELECT *, 
        row_number() over(
            partition by cd_periodicite_remboursement 
            order by lb_periodicite_remboursement) as rn
FROM cleaned_TB_PERIODICITE_REMBOURSEMENT