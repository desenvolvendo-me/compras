class AddPropertyVariableSettingTwoValueToCategoryPointConstructions < ActiveRecord::Migration
  def change
    add_column :category_point_constructions, :property_variable_setting_two_value, :string
  end
end
