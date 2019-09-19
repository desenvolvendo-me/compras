class RemoveCreditor < ActiveRecord::Migration
  def change
    remove_table :compras_pledge_liquidation_parcel_retentions
    remove_table :compras_pledge_liquidation_parcel_payers
    remove_table :compras_pledge_liquidation_parcel_payment_closings
    remove_table :compras_payment_reversal_closings
    remove_table :compras_pledge_liquidation_parcel_payment_reversals
    remove_table :compras_bank_reconciliation_items
    remove_table :compras_pledge_liquidation_parcel_payments
    remove_table :compras_pledge_liquidation_parcels
    remove_table :contabilidade_fiscal_note_items
    remove_table :contabilidade_fiscal_notes
    remove_table :compras_pledge_liquidations
    remove_table :compras_pledge_items
    remove_table :compras_pledge_cancellations
    remove_table :compras_pledge_request_items
    remove_table :compras_pledge_requests
    remove_table :compras_pledges
    remove_table :compras_extra_budget_pledge_items
    remove_table :compras_extra_budget_pledges
    #drop_table :compras_creditors
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
