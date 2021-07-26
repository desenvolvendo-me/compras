class AddQuantityUnitToMaterials < ActiveRecord::Migration
  def change
    add_column :unico_materials, :quantity_unit, :integer
  end
end
