with cleaned_TB_STATUT_PRET as
(
    select nullif(trim(cd_statut_pret),'')  as cd_statut_pret,
        nullif(trim(regexp_replace(initcap(lb_statut_pret), '\\s+', ' ')),'')  as lb_statut_pret
     from {{source('bronze', 'TB_STATUT_PRET')}}
)

SELECT *, 
        row_number() over(
            partition by cd_statut_pret 
            order by lb_statut_pret) as rn
FROM cleaned_TB_STATUT_PRET