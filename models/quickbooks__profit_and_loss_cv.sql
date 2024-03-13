with general_ledger_by_period as (

    select *
    from {{ ref('quickbooks__general_ledger_by_period') }}
    where financial_statement_helper = 'income_statement'
),  

customers as (

    select *
    from {{ ref('stg_quickbooks__customer') }}
),

vendors as (

    select *
    from {{ ref('stg_quickbooks__vendor') }}
),

final as (
    select
        period_first_day as calendar_date,
        general_ledger_by_period.source_relation,
        account_class,
        class_id,
        general_ledger_by_period.customer_id, 
        customers.display_name as customer_name,
        general_ledger_by_period.vendor_id,
        vendors.display_name as vendor_name,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        general_ledger_by_period.account_number,
        account_id,
        account_name,
        period_net_change as amount,
        account_ordinal
    from general_ledger_by_period

    left join customers
        on customers.customer_id = general_ledger_by_period.customer_id
        and customers.source_relation = general_ledger_by_period.source_relation

    left join vendors
        on vendors.vendor_id = general_ledger_by_period.vendor_id
        and vendors.source_relation = general_ledger_by_period.source_relation    
)

select *
from final