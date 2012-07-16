class CreatePurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_item_groups do |t|
      t.references :material

      t.timestamps
    end

    add_index :compras_purchase_solicitation_item_groups, :material_id, :name => :cpsig_material_id
    add_foreign_key :compras_purchase_solicitation_item_groups, :compras_materials, :name => :cpsig_material_fk, :column => :material_id
  end
end
