class AddSelfAssociationKeysToPropertyVariableSettings < ActiveRecord::Migration
  def change
    add_index :property_variable_settings, :dependency_id
    add_foreign_key :property_variable_settings, :property_variable_settings, :column => :dependency_id
  end
end
