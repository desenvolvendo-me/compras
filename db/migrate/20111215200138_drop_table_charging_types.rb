class DropTableChargingTypes < ActiveRecord::Migration
  def change
    drop_table :charging_types
  end
end
