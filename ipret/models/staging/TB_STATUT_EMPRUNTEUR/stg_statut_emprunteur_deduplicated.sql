with cleaned_TB_statut_EMPRUNTEUR as
(
    select nullif(trim(cd_statut_emprunteur),'')  as cd_statut_emprunteur,
        nullif(trim(regexp_replace(initcap(lb_statut_emprunteur), '\\s+', ' ')),'')  as lb_statut_emprunteur
     from {{source('bronze', 'TB_STATUT_EMPRUNTEUR')}}
)

SELECT *, 
        row_number() over(
            partition by cd_statut_emprunteur 
            order by lb_statut_emprunteur) as rn
FROM cleaned_TB_statut_EMPRUNTEUR