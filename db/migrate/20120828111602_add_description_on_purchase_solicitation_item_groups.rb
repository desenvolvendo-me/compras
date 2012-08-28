class AddDescriptionOnPurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_item_groups, :description, :string

    PurchaseSolicitationItemGroup.update_all('description = id')
  end
end
