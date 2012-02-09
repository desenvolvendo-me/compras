class ChangeMaterialsGroupNameToDescription < ActiveRecord::Migration
  def change
    rename_column :materials_groups, :name, :description
  end
end
