class AddRequestedQuantityToSupplyRequestItem < ActiveRecord::Migration
  def change
    add_column :compras_supply_request_items,
               :requested_quantity, :integer
  end
end
