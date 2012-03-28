class RenameTableAdministractiveActToRegulatoryAct < ActiveRecord::Migration
  def change
    rename_table :administractive_acts, :regulatory_acts

    rename_column :expense_economic_classifications, :administractive_act_id, :regulatory_act_id
    rename_column :organogram_configurations,        :administractive_act_id, :regulatory_act_id
    rename_column :organogram_responsibles,          :administractive_act_id, :regulatory_act_id
    rename_column :licitation_modalities,            :administractive_act_id, :regulatory_act_id
    rename_column :functions,                        :administractive_act_id, :regulatory_act_id
    rename_column :additional_credit_openings,       :administractive_act_id, :regulatory_act_id

    rename_table :administractive_acts_dissemination_sources, :dissemination_sources_regulatory_acts

    rename_column :dissemination_sources_regulatory_acts, :administractive_act_id, :regulatory_act_id
  end
end
