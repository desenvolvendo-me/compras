class AddPolymorphyToFieldValues < ActiveRecord::Migration
  def up
    add_column :field_values, :object_setting_id, :integer
    add_column :field_values, :object_setting_type, :string
    add_index :field_values, :object_setting_id
    add_index :field_values, :object_setting_type

    #FieldValue.all.each do |field|
      #field.object_setting_id   = field.property_id
      #field.object_setting_type = "Property"
      #field.save
    #end
  end

  def down
    remove_column :field_values, :object_setting_id
    remove_column :field_values, :object_setting_type
  end
end
