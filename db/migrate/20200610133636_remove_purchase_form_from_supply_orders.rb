class RemovePurchaseFormFromSupplyOrders < ActiveRecord::Migration
  def up
    remove_column :compras_supply_orders, :purchase_form_id
  end

  def down
    add_column :compras_supply_orders, :purchase_form_id, :integer
  end
end
