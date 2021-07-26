class AddSupplyRequestFileToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :supply_request_file, :string
  end
end
