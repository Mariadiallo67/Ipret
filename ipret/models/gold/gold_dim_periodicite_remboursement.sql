{{ config(alias='dim_periodicite_remboursement') }}

select * from {{ ref('dim_periodicite_remboursement') }}