class RemoveMaterialFromPurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_solicitation_item_groups, :purchase_solicitation_item_group_material_id
  end
end
