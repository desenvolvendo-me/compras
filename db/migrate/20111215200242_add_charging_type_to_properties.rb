class AddChargingTypeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :charging_type, :string
  end
end
