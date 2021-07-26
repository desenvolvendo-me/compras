class AddUnicoCreditorToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :creditor_id, :integer

    add_index :compras_supply_orders, :creditor_id
    add_foreign_key :compras_supply_orders, :unico_creditors, column: :creditor_id
  end
end
