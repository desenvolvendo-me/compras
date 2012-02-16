class RenameTableTypeOfAdministractiveActToAdministractiveActType < ActiveRecord::Migration
  def change
    rename_table :type_of_administractive_acts, :administractive_act_types
  end
end
