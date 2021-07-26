class RemovePurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_solicitation_budget_allocation_items, :purchase_solicitation_item_group_id
    drop_table :compras_item_group_material_purchase_solicitations
    drop_table :compras_purchase_solicitation_item_group_materials
    drop_table :compras_purchase_solicitation_item_groups
  end
end
