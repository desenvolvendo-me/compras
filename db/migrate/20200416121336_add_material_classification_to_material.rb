class AddMaterialClassificationToMaterial < ActiveRecord::Migration
  def change
    add_column :compras_materials, :material_classification, :string
  end
end
