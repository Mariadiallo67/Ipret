{{ config(alias='dim_mode_remboursement') }}

select * from {{ ref('dim_mode_remboursement') }}