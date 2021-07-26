class AddMaterialIdToSupplyOrderItems < ActiveRecord::Migration
  def change
    add_column :compras_supply_order_items, :material_id, :integer

    add_index :compras_supply_order_items, :material_id

    add_foreign_key :compras_supply_order_items, :compras_materials, column: :material_id
  end
end
