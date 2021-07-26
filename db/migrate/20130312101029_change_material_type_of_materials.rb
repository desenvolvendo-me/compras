class ChangeMaterialTypeOfMaterials < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE compras_materials
        SET material_type = 'asset'
      WHERE material_type = 'permanent'
    SQL
  end
end
