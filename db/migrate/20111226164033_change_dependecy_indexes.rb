class ChangeDependecyIndexes < ActiveRecord::Migration
  def change
    remove_foreign_key :property_variable_settings, :column => :dependency_id
    add_index :property_variable_settings, :dependency_type
  end
end
