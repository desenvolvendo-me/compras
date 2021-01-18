class ChangePrecisionUnitPriceFromPurchaseSolicitationItem < ActiveRecord::Migration
  def change
    change_column :compras_purchase_solicitation_items, :unit_price, :decimal, :precision => 10, :scale => 3
  end
end
