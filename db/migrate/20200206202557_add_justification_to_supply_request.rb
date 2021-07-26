class AddJustificationToSupplyRequest < ActiveRecord::Migration
  def change
    add_column :compras_supply_requests, :justification, :text
  end
end
