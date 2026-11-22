with cleaned_TB_TYPE_PRET as
(
    select nullif(trim(cd_type_pret),'')  as cd_type_pret,
        nullif(trim(regexp_replace(initcap(lb_type_pret), '\\s+', ' ')),'')  as lb_type_pret
     from {{source('bronze', 'TB_TYPE_PRET')}}
)

SELECT *, 
        row_number() over(
            partition by cd_type_pret 
            order by lb_type_pret) as rn
FROM cleaned_TB_TYPE_PRET