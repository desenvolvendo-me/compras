class AddOldUnitPriceToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :old_unit_price,
      :decimal, precision: 10, scale: 2
  end
end
