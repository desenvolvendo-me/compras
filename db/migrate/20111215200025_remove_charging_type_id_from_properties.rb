class RemoveChargingTypeIdFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :charging_type_id
  end
end
