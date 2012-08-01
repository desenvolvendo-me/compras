class CreatePurchaseSolicitationItemGroupMaterials < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_item_group_materials do |t|
      t.references :purchase_solicitation_item_group
      t.references :material

      t.timestamps
    end

    add_index :compras_purchase_solicitation_item_group_materials, :purchase_solicitation_item_group_id, :name => :cpsigm_purchase_solicitation_item_group_id
    add_index :compras_purchase_solicitation_item_group_materials, :material_id, :name => :cpsigm_material_id
    add_foreign_key :compras_purchase_solicitation_item_group_materials, :compras_purchase_solicitation_item_groups, :name => :cpsigm_purchase_solicitation_item_group_fk, :column => :purchase_solicitation_item_group_id
    add_foreign_key :compras_purchase_solicitation_item_group_materials, :compras_materials, :name => :cpsigm_material_fk, :column => :material_id
  end
end
