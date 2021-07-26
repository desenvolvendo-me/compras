class RemoveMaterialClassIdFromPurchaseProcessFractionation < ActiveRecord::Migration
  def up
    remove_column :compras_purchase_process_fractionations,
                  :material_class_id
  end

  def down
    add_column :compras_purchase_process_fractionations,
               :material_class_id, :integer
    add_index :compras_purchase_process_fractionations, :material_class_id
    add_foreign_key :compras_purchase_process_fractionations,
                    :compras_material_classes,
                    column: :material_class_id
  end
end
