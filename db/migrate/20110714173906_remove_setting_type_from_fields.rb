class RemoveSettingTypeFromFields < ActiveRecord::Migration
  def up
    remove_column :fields, :setting_type
  end

  def down
    add_column :fields, :setting_type, :string
  end
end
