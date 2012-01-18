class AddOrderToPropertyVariableSettings < ActiveRecord::Migration
  def change
    add_column :property_variable_settings, :order, :integer
  end
end
