{{ config(alias='fact_pret') }}

select * from {{ ref('fact_pret') }}