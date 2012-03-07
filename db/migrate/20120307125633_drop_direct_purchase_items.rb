class DropDirectPurchaseItems < ActiveRecord::Migration
  def change
    remove_foreign_key :direct_purchase_items, :direct_purchases
    remove_foreign_key :direct_purchase_items, :materials
    drop_table :direct_purchase_items
  end
end
