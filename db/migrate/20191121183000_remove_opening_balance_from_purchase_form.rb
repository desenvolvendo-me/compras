class RemoveOpeningBalanceFromPurchaseForm < ActiveRecord::Migration
  def up
    remove_column :compras_purchase_forms,
                  :opening_balance
  end

  def down
    add_column :compras_purchase_forms,
               :opening_balance, :decimal,
               :precision => 20, :scale => 2
  end
end
