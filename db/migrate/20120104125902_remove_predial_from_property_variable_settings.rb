class RemovePredialFromPropertyVariableSettings < ActiveRecord::Migration
  def change
    remove_column :property_variable_settings, :predial
  end
end
