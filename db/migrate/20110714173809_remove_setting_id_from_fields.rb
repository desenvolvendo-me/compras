class RemoveSettingIdFromFields < ActiveRecord::Migration
  def up
    remove_column :fields, :setting_id
  end

  def down
    add_column :fields, :setting_id, :integer
  end
end
