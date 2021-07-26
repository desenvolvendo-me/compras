class RemovePurchaseSolicitationItemGroupFromDirectPurchases < ActiveRecord::Migration
  def change
    remove_column :compras_direct_purchases, :purchase_solicitation_item_group_id
  end
end
