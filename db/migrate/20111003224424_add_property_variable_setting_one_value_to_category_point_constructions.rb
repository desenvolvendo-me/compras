class AddPropertyVariableSettingOneValueToCategoryPointConstructions < ActiveRecord::Migration
  def change
    add_column :category_point_constructions, :property_variable_setting_one_value, :string
  end
end
