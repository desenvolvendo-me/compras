class AddStatusToPurchaseSolicitationItemGroup < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_item_groups, :status, :string

    add_index :compras_purchase_solicitation_item_groups, :status
  end
end
