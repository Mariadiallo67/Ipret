select
    p.id_pret,
    ca.id_dim_calendar,
    e.id_dim_emprunteur,
    t.id_dim_type_pret,
    s.id_dim_statut_pret,
    per.id_dim_periodicite_remboursement,
    p.mt_pret,
    p.nb_duree_remboursement,
    p.tx_interet_pret,
    1 as nb_pret
from {{ ref('stg_pret') }} p
    left join {{ ref('dim_calendar') }}                   ca  on p.dt_pret = ca.dt_calendar
    left join {{ ref('dim_emprunteur') }}                 e   on p.id_emprunteur = e.id_emprunteur
    left join {{ ref('dim_type_pret') }}                  t   on p.cd_type_pret = t.cd_type_pret
    left join {{ ref('dim_statut_pret') }}                s   on p.cd_statut_pret = s.cd_statut_pret
    left join {{ ref('dim_periodicite_remboursement') }}  per on p.cd_periodicite_remboursement = per.cd_periodicite_remboursement
where ca.id_dim_calendar is not null
  and e.id_dim_emprunteur is not null
  and t.id_dim_type_pret is not null
  and s.id_dim_statut_pret is not null
  and per.id_dim_periodicite_remboursement is not null