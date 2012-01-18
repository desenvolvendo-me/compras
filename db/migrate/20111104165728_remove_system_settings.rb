class RemoveSystemSettings < ActiveRecord::Migration
  def change
    drop_table :system_settings
  end
end
