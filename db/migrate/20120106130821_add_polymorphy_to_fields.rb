class AddPolymorphyToFields < ActiveRecord::Migration
  def up
    add_column :fields, :object_setting_id, :integer
    add_column :fields, :object_setting_type, :string
    add_index  :fields, :object_setting_id
    add_index  :fields, :object_setting_type

    #Field.all.each do |f|
      #f.object_setting_id   = f.property_setting_id
      #f.object_setting_type = 'PropertySetting'
      #f.save
    #end
  end

  def down
    remove_column :fields, :object_setting_id
    remove_column :fields, :object_setting_type
  end
end
