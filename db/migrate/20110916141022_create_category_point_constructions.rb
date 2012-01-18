class CreateCategoryPointConstructions < ActiveRecord::Migration
  def change
    create_table :category_point_constructions do |t|
      t.integer :year
      t.references :property_variable_setting_one
      t.references :property_variable_setting_two
      t.references :property_variable_setting_three
      t.integer :value

      t.timestamps
    end
    add_index :category_point_constructions, :property_variable_setting_one_id, :name => 'index_category_point_constructions_property_var_setting_one'
    add_index :category_point_constructions, :property_variable_setting_two_id, :name => 'index_category_point_constructions_property_var_setting_two'
    add_index :category_point_constructions, :property_variable_setting_three_id, :name => 'index_category_point_constructions_property_var_setting_three'
    add_foreign_key :category_point_constructions, :property_variable_settings, :column => :property_variable_setting_one_id, :name => 'fk_category_point_constructions_property_var_setting_one'
    add_foreign_key :category_point_constructions, :property_variable_settings, :column => :property_variable_setting_two_id, :name => 'fk_category_point_constructions_property_var_setting_two'
    add_foreign_key :category_point_constructions, :property_variable_settings, :column => :property_variable_setting_three_id, :name => 'fk_category_point_constructions_property_var_setting_three'
  end
end
