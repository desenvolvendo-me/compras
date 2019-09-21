class CreatePurchaseSolicitationMaterials < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_materials do |t|
      t.references :purchase_solicitation
      t.references :material

      t.timestamps
    end

    add_index :compras_purchase_solicitation_materials, :purchase_solicitation_id,
              name: :cpsm_purchase_solicitation_id
    add_foreign_key :compras_purchase_solicitation_materials, :compras_purchase_solicitations,
                    column: :purchase_solicitation_id,name: :cpsm_purchase_solicitation_fk

    add_index :compras_purchase_solicitation_materials, :material_id,
              name: :cpsm_purchase_material_id
    add_foreign_key :compras_purchase_solicitation_materials, :compras_purchase_solicitations,
                    column: :material_id,name: :cpsm_material_fk
  end

end
