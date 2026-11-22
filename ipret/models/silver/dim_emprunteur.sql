with postal as
(
    select code_postal, code_commune_postal
    from {{ ref('stg_file_zone_geographique') }}
    qualify row_number() over (
        partition by code_postal
        order by code_commune_postal
    ) = 1
)

select
    row_number() over (order by s.id_emprunteur, s.dbt_valid_from) as id_dim_emprunteur,
    s.dbt_valid_from                                               as valid_from,
    s.dbt_valid_to                                                 as valid_to,
    case when s.dbt_valid_to is null then 1 else 0 end as is_current_version,
    s.id_emprunteur,
    s.lb_civilite_emprunteur,
    s.lb_nom_emprunteur,
    s.lb_prenom_emprunteur,
    s.dt_naissance_emprunteur,
    s.lb_email_emprunteur,
    s.cd_postal_emprunteur,
    pc.id_dim_postal_code,
    t.id_dim_type_emprunteur,
    st.id_dim_statut_emprunteur
from {{ ref('snap_emprunteur') }} s
    left join postal z                          on z.code_postal = s.cd_postal_emprunteur
    left join {{ ref('dim_code_postal') }} pc   on pc.cd_postal = z.code_commune_postal
    left join {{ ref('dim_type_emprunteur') }}   t  on t.cd_type_emprunteur   = s.cd_type_emprunteur
    left join {{ ref('dim_statut_emprunteur') }} st on st.cd_statut_emprunteur = s.cd_statut_emprunteur