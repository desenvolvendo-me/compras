class AddSecretaryToOrderSupply < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :secretary_id, :integer

    add_index :compras_supply_orders, :secretary_id
    add_foreign_key :compras_supply_orders, :compras_secretaries,
                    column: :secretary_id
  end
end
