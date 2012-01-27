class RenameServiceTypesDescriptionToName < ActiveRecord::Migration
  def change
    rename_column :service_types, :description, :name
  end
end
