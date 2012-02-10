class RenameTypeOfAdministractiveActsNameToDescription < ActiveRecord::Migration
  def change
    rename_column :type_of_administractive_acts, :name, :description
  end
end
