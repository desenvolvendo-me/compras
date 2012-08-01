class RenameFieldsPurchaseSolicitationItemGroupId < ActiveRecord::Migration
  def change
    remove_column :compras_item_group_material_purchase_solicitations, :purchase_solicitation_item_group_id
    add_column :compras_item_group_material_purchase_solicitations, :purchase_solicitation_item_group_material_id, :integer

    add_index :compras_item_group_material_purchase_solicitations, :purchase_solicitation_item_group_material_id, :name => :cigmps_purchase_solicitation_item_group_material_id
    add_foreign_key :compras_item_group_material_purchase_solicitations, :compras_purchase_solicitation_item_group_materials, :column => :purchase_solicitation_item_group_material_id, :name => :cigmps_purchase_solicitation_item_group_material_id_fk
  end
end
