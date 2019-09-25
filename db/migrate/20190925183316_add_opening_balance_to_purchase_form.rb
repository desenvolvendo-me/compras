class AddOpeningBalanceToPurchaseForm < ActiveRecord::Migration

  def up
    add_column :compras_purchase_forms,
               :opening_balance,
               :decimal,:precision => 15, :scale => 2
  end

  def down
    remove_column :compras_purchase_forms,
                  :opening_balance
  end

end
