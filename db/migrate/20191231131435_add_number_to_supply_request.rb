class AddNumberToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :number, :string
  end
end
