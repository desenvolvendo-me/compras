class RenameTableAdministractiveActTypeClassificationsToRegulatoryActTypeClassifications < ActiveRecord::Migration
  def change
    rename_table :administractive_act_type_classifications, :regulatory_act_type_classifications

    rename_column :administractive_act_types, :administractive_act_type_classification_id, :regulatory_act_type_classification_id
  end
end
