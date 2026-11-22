{{ config(alias='fact_remboursement') }}

select * from {{ ref('fact_remboursement') }}