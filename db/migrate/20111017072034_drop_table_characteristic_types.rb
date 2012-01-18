class DropTableCharacteristicTypes < ActiveRecord::Migration
  def change
    drop_table :characteristic_types
  end
end
