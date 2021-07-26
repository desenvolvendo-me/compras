class RemoveOldTables < ActiveRecord::Migration
  def change
    remove_table :compras_bank_account_capabilities
    remove_table :compras_agreement_bank_accounts
    remove_table :compras_tax_revenue_reversings
    remove_table :compras_tax_revenue_receipt_reversings
    remove_table :compras_tax_revenue_receipts
    remove_table :compras_tax_revenue_closings
    remove_table :compras_tax_revenues
    remove_table :compras_pledge_liquidation_parcel_payers
    remove_table :compras_payment_reversal_closings
    remove_table :compras_pledge_liquidation_parcel_payment_reversals
    remove_table :compras_pledge_liquidation_parcel_payment_closings
    remove_table :compras_pledge_liquidation_parcel_retentions
    remove_table :compras_bank_reconciliation_items
    remove_table :compras_pledge_liquidation_parcel_payments
    remove_table :compras_pledge_liquidation_parcels
    remove_table :compras_extra_budget_pledge_payments
    remove_table :compras_bank_transfer_closings
    remove_table :compras_bank_transfers
    remove_table :compras_voided_checks
    remove_table :compras_checkbooks
    remove_table :compras_bank_reconciliations
    remove_table :compras_account_movements
  end

  protected

  def remove_table(table_name)
    if connection.table_exists? table_name
      drop_table table_name
    end
  end

  def connection
    ActiveRecord::Base.connection
  end
end
