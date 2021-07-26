class RemoveStatusFromComprasDirectPurchases < ActiveRecord::Migration
  def change
    remove_column :compras_direct_purchases, :status
  end
end
