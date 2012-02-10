class RenameAdministrationTypesNameToDescription < ActiveRecord::Migration
  def change
    rename_column :administration_types, :name, :description
  end
end
