class AddActiveToComprasMaterials < ActiveRecord::Migration
  def change
    add_column :compras_materials, :active, :boolean, :default => true
  end
end
