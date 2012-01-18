class RemoveTerritorialFromPropertyVariableSettings < ActiveRecord::Migration
  def change
    remove_column :property_variable_settings, :territorial
  end
end
