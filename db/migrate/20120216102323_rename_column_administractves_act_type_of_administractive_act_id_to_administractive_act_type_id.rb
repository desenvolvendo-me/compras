class RenameColumnAdministractvesActTypeOfAdministractiveActIdToAdministractiveActTypeId < ActiveRecord::Migration
  def change
    rename_column :administractive_acts, :type_of_administractive_act_id, :administractive_act_type_id
  end
end
