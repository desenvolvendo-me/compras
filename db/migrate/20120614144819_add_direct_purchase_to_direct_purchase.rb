class AddDirectPurchaseToDirectPurchase < ActiveRecord::Migration
  def change
    add_column :compras_direct_purchases, :direct_purchase, :integer

    add_index :compras_direct_purchases, :direct_purchase, :unique => true
  end
end
