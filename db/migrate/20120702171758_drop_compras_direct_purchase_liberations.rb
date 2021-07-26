class DropComprasDirectPurchaseLiberations < ActiveRecord::Migration
  def change
    drop_table :compras_direct_purchase_liberations
  end
end
