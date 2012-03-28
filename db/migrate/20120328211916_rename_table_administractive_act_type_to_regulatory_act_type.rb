class RenameTableAdministractiveActTypeToRegulatoryActType < ActiveRecord::Migration
  def change
    rename_table :administractive_act_types, :regulatory_act_types

    rename_column :administractive_acts, :administractive_act_type_id, :regulatory_act_type_id
  end
end
