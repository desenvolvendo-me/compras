class AddMaterialIdToPurchaseSolicitationItem < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_items,
               :material_id, :integer
    add_index :compras_purchase_solicitation_items, :material_id
    # add_foreign_key :compras_purchase_solicitation_items, :unico_materials,
    #                 column: :material_id
  end
end
