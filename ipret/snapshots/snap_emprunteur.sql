{% snapshot snap_emprunteur %}
{{
    config(
        schema='snapshots',
        unique_key='id_emprunteur',
        strategy='check',
        check_cols=['cd_postal_emprunteur', 'cd_type_emprunteur', 'cd_statut_emprunteur', 'lb_civilite_emprunteur','lb_nom_emprunteur',
    'lb_prenom_emprunteur', 'dt_naissance_emprunteur','lb_email_emprunteur',]
    )
}}

select * from {{ ref('stg_emprunteur') }}

{% endsnapshot %}