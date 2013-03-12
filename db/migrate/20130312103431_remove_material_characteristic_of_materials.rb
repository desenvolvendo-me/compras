class RemoveMaterialCharacteristicOfMaterials < ActiveRecord::Migration
  def change
    remove_column :compras_materials, :material_characteristic
  end
end
