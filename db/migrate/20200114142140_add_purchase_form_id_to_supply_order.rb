class AddPurchaseFormIdToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :purchase_form_id, :integer
  end
end
