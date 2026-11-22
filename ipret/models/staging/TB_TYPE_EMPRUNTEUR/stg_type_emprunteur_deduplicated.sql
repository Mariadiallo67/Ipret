with cleaned_TB_TYPE_EMPRUNTEUR as
(
    select nullif(trim(cd_type_emprunteur),'')  as cd_type_emprunteur,
        nullif(trim(regexp_replace(initcap(lb_type_emprunteur), '\\s+', ' ')),'')  as lb_type_emprunteur
     from {{source('bronze', 'TB_TYPE_EMPRUNTEUR')}}
)

SELECT *, 
        row_number() over(
            partition by cd_type_emprunteur 
            order by lb_type_emprunteur) as rn
FROM cleaned_TB_TYPE_EMPRUNTEUR