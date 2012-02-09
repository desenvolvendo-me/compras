class RenameOrganogramLevelsNameToDescription < ActiveRecord::Migration
  def change
    rename_column :organogram_levels, :name, :description
  end
end
