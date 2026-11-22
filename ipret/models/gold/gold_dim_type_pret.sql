{{ config(alias='dim_type_pret') }}

select * from {{ ref('dim_type_pret') }}