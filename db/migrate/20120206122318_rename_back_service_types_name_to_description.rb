class RenameBackServiceTypesNameToDescription < ActiveRecord::Migration
  def change
    rename_column :service_types, :name, :description
  end
end
