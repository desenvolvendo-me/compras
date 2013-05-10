class DropRegulatoryActTypeClassifications < ActiveRecord::Migration
  def change
    remove_column 'compras_regulatory_act_types', 'regulatory_act_type_classification_id'

    drop_table :compras_regulatory_act_type_classifications
  end
end
