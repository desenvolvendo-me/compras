class AddPurchaseSolicitationToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders,
               :purchase_solicitation_id, :integer
    add_index :compras_supply_orders, :purchase_solicitation_id
    add_foreign_key :compras_supply_orders, :compras_purchase_solicitations,
                    :column => :purchase_solicitation_id
  end
end