{{ config(alias='dim_emprunteur') }}

with geographic_area as (
    select
        pc.id_dim_postal_code,
        pc.cd_postal,
        pc.postal_commune_name,
        d.cd_department,
        d.department_name,
        r.cd_region,
        r.region_name,
        c.cd_country,
        c.lib_country
        
    from {{ ref('dim_code_postal') }} pc
        inner join {{ ref('dim_department') }} d
            on pc.id_dim_department = d.id_dim_department
        inner join {{ ref('dim_region') }} r
            on d.id_dim_region = r.id_dim_region
        inner join {{ ref('dim_country') }} c
            on r.id_dim_country = c.id_dim_country
)

select
    e.id_dim_emprunteur,
    e.valid_from,
    e.valid_to,
    e.is_current_version,
    e.id_emprunteur,
    e.lb_civilite_emprunteur,
    e.lb_nom_emprunteur,
    e.lb_prenom_emprunteur,
    e.dt_naissance_emprunteur,
    e.lb_email_emprunteur,
    e.cd_postal_emprunteur,
    e.id_dim_postal_code,
    te.cd_type_emprunteur,
    te.lb_type_emprunteur,
    se.cd_statut_emprunteur,
    se.lb_statut_emprunteur,
    ga.cd_postal,
    ga.postal_commune_name,
    ga.cd_department,
    ga.department_name,
    ga.cd_region,
    ga.region_name,
    ga.cd_country,
    ga.lib_country
from {{ ref('dim_emprunteur') }} e
    inner join {{ ref('dim_type_emprunteur') }} te
        on e.id_dim_type_emprunteur = te.id_dim_type_emprunteur
    inner join {{ ref('dim_statut_emprunteur') }} se
        on e.id_dim_statut_emprunteur = se.id_dim_statut_emprunteur
    left join geographic_area ga
        on e.id_dim_postal_code = ga.id_dim_postal_code