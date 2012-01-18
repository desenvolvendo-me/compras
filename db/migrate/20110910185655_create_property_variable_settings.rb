class CreatePropertyVariableSettings < ActiveRecord::Migration
  def change
    create_table :property_variable_settings do |t|
      t.integer :year
      t.string :code
      t.references :field_type
      t.string :name
      t.text :description
      t.boolean :required, :default => false
      t.boolean :territorial, :default => false
      t.boolean :predial, :default => false
      t.integer :dependency_id
      t.references :reference_unit
      t.boolean :used_database_projects
      t.references :property

      t.timestamps
    end
    add_index :property_variable_settings, :field_type_id
    add_index :property_variable_settings, :reference_unit_id
    add_index :property_variable_settings, :property_id
  end
end
