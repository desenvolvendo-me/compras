class AddReadOnlyToPropertyVariableSettings < ActiveRecord::Migration
  def change
    add_column :property_variable_settings, :read_only, :boolean, :default => false
  end
end
