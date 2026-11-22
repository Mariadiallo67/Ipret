{{ config(materialized='table') }}

select
    id_emprunteur,
    lb_civilite_emprunteur,
    lb_nom_emprunteur,
    lb_prenom_emprunteur,
    dt_naissance_emprunteur,
    lb_email_emprunteur,
    cd_postal_emprunteur,
    cd_type_emprunteur,
    cd_statut_emprunteur
from {{ ref('stg_emprunteur_deduplicated') }}
where rn = 1
  and id_emprunteur is not null
  and lb_nom_emprunteur is not null
  and lb_prenom_emprunteur is not null
  and dt_naissance_emprunteur is not null
  and cd_type_emprunteur is not null
  and cd_statut_emprunteur is not null