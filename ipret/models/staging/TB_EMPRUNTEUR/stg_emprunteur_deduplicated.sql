{{ config(materialized='view') }}

with cleaned_emprunteur as
(
    select
        try_to_number(nullif(trim(id_emprunteur), ''))                                   as id_emprunteur,
        iff(upper(trim(lb_civilite_emprunteur)) in ('', '-', 'N/A', 'NULL'),
            null, trim(lb_civilite_emprunteur))                                          as lb_civilite_emprunteur,
        nullif(regexp_replace(trim(lb_nom_emprunteur), '\\s+', ' '), '')                 as lb_nom_emprunteur,
        nullif(regexp_replace(initcap(trim(lb_prenom_emprunteur)), '\\s+', ' '), '')     as lb_prenom_emprunteur,
        try_to_date(trim(dt_naissance_emprunteur), 'DD/MM/YYYY')                         as dt_naissance_emprunteur,
        iff(upper(trim(lb_email_emprunteur)) in ('', '-', 'N/A', 'NULL'),
            null, lower(trim(lb_email_emprunteur)))                                      as lb_email_emprunteur,
        iff(upper(trim(cd_postal_emprunteur)) in ('', '-', 'N/A', 'NULL'),
            null, trim(cd_postal_emprunteur))                                            as cd_postal_emprunteur,
        nullif(upper(trim(cd_type_emprunteur)), '')                                      as cd_type_emprunteur,
        nullif(upper(trim(cd_statut_emprunteur)), '')                                    as cd_statut_emprunteur
    from {{ source('bronze', 'TB_EMPRUNTEUR') }}
)

select
    *,
    row_number() over (
        partition by id_emprunteur
        order by lb_nom_emprunteur, lb_prenom_emprunteur
    ) as rn
from cleaned_emprunteur