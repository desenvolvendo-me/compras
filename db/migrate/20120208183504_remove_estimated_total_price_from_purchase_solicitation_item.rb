class RemoveEstimatedTotalPriceFromPurchaseSolicitationItem < ActiveRecord::Migration
  def change
    remove_column :purchase_solicitation_items, :estimated_total_price
  end
end
