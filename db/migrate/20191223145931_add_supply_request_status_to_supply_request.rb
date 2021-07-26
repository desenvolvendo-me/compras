class AddSupplyRequestStatusToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :supply_request_status, :string
  end
end
