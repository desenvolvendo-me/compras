class AddDependencyTypeToPropertyVariableSettings < ActiveRecord::Migration
  def change
    add_column :property_variable_settings, :dependency_type, :string
  end
end
