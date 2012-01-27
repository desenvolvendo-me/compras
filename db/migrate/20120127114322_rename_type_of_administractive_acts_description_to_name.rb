class RenameTypeOfAdministractiveActsDescriptionToName < ActiveRecord::Migration
  def change
    rename_column :type_of_administractive_acts, :description, :name
  end
end
