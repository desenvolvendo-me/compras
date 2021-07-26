class AddLotToPurchaseSolicitationItem < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_items, :lot, :integer
  end
end
