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
    cd_statut_emprunteur,
    convert_timezone('Europe/Paris', current_timestamp()) as rejected_at,
    case
        when id_emprunteur is null          then 'missing emprunteur id'
        when lb_nom_emprunteur is null      then 'missing nom'
        when lb_prenom_emprunteur is null   then 'missing prenom'
        when dt_naissance_emprunteur is null then 'missing or invalid birth date'
        when cd_type_emprunteur is null     then 'missing type emprunteur code'
        when cd_statut_emprunteur is null   then 'missing statut emprunteur code'
        when rn > 1                         then 'duplicate key'
    end as rejected_reason
from {{ ref('stg_emprunteur_deduplicated') }}
where rn > 1
   or id_emprunteur is null
   or lb_nom_emprunteur is null
   or lb_prenom_emprunteur is null
   or dt_naissance_emprunteur is null
   or cd_type_emprunteur is null
   or cd_statut_emprunteur is null