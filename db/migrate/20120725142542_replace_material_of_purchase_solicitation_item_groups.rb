class ReplaceMaterialOfPurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_solicitation_item_groups, :material_id
    add_column :compras_purchase_solicitation_item_groups, :purchase_solicitation_item_group_material_id, :integer

    add_index :compras_purchase_solicitation_item_groups, :purchase_solicitation_item_group_material_id, :name => :cpsig_purchase_solicitation_item_group_material_id
    add_foreign_key :compras_purchase_solicitation_item_groups, :compras_purchase_solicitation_item_groups, :name => :cpsig_purchase_solicitation_item_group_fk, :column => :purchase_solicitation_item_group_material_id
  end
end
