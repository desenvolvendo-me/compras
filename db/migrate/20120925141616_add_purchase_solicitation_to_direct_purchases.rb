class AddPurchaseSolicitationToDirectPurchases < ActiveRecord::Migration
  def change
    add_column :compras_direct_purchases, :purchase_solicitation_id, :integer
  end
end
