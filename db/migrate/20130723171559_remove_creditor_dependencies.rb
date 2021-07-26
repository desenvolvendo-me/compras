class RemoveCreditorDependencies < ActiveRecord::Migration
  def change
    remove_table :compras_agreement_participants
    remove_table :compras_pledge_liquidation_parcels
    remove_table :contabilidade_fiscal_note_items
    remove_table :contabilidade_fiscal_notes
    remove_table :compras_pledge_liquidations
    remove_table :compras_pledge_items
    remove_table :compras_pledge_cancellations
    remove_table :compras_pledges
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
