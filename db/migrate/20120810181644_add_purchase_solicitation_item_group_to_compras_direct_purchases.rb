class AddPurchaseSolicitationItemGroupToComprasDirectPurchases < ActiveRecord::Migration
  def change
    add_column :compras_direct_purchases, :purchase_solicitation_item_group_id, :integer

    add_index :compras_direct_purchases, :purchase_solicitation_item_group_id, :name => :ps_item_group_idx
    add_foreign_key :compras_direct_purchases, :compras_purchase_solicitation_item_groups, :column => :purchase_solicitation_item_group_id
  end
end
