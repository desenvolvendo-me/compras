class RemoveFieldsOfMaterials < ActiveRecord::Migration
  def up
    remove_column :compras_materials, :unit_price
    remove_column :compras_materials, :minimum_stock_balance
    remove_column :compras_materials, :stock_balance
    remove_column :compras_materials, :cash_balance
    remove_column :compras_materials, :perishable
    remove_column :compras_materials, :storable
  end
end
