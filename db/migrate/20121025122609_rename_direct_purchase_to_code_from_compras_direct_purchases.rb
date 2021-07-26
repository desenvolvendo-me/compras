class RenameDirectPurchaseToCodeFromComprasDirectPurchases < ActiveRecord::Migration
  def change
    rename_column :compras_direct_purchases, :direct_purchase, :code
  end
end
