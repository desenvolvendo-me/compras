class RemovePropertyIdFromPropertyVariableSettings < ActiveRecord::Migration
  def up
    remove_column :property_variable_settings, :property_id
  end

  def down
    add_column :property_variable_settings, :property_id, :integer
  end
end
