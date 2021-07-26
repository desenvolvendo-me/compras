class RemoveSettingsTable < ActiveRecord::Migration
  def change
    drop_table :compras_settings
  end
end
