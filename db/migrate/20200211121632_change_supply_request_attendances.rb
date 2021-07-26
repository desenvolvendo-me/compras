class ChangeSupplyRequestAttendances < ActiveRecord::Migration
  def change
    rename_table :compras_supply_request_deferrings, :compras_supply_request_attendances
  end
end
