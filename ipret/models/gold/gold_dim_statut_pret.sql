{{ config(alias='dim_statut_pret') }}

select * from {{ ref('dim_statut_pret') }}