class RemoveMaterialsGroupFromMaterials < ActiveRecord::Migration
  def change
    remove_index :materials, :materials_group_id
    remove_foreign_key :materials, :materials_groups
    remove_column :materials, :materials_group_id
  end
end
