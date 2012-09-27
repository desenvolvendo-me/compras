class AddFkToDirectPurchasePurchaseSolicitation < ActiveRecord::Migration
  def change
    add_index :compras_direct_purchases, :purchase_solicitation_id

    add_foreign_key :compras_direct_purchases, :compras_purchase_solicitations,
                    :column => :purchase_solicitation_id
  end
end
