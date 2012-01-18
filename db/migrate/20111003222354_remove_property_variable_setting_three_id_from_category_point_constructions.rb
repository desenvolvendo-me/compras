class RemovePropertyVariableSettingThreeIdFromCategoryPointConstructions < ActiveRecord::Migration
  def up
    remove_column :category_point_constructions, :property_variable_setting_three_id
  end

  def down
    add_column :category_point_constructions, :property_variable_setting_three_id, :integer
    add_index :category_point_constructions, :property_variable_setting_three_id, :name => 'index_category_point_constructions_property_var_setting_three'
    add_foreign_key :category_point_constructions, :property_variable_settings, :column => :property_variable_setting_three_id, :name => 'fk_category_point_constructions_property_var_setting_three'
  end
end
