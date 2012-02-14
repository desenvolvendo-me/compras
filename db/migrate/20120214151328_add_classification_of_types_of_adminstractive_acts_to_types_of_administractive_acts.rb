class AddClassificationOfTypesOfAdminstractiveActsToTypesOfAdministractiveActs < ActiveRecord::Migration
  def change
    add_column :type_of_administractive_acts, :classification_of_types_of_administractive_act_id, :integer
    add_index :type_of_administractive_acts, :classification_of_types_of_administractive_act_id, :name => 'index_toac_cofac'
    add_foreign_key :type_of_administractive_acts, :classification_of_types_of_administractive_acts, :name => 'toac_cofac_fk'
  end
end
