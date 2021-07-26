class AddMaterialClassIdToPurchaseProcessFractionation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_fractionations,
               :material_class_id, :integer
    add_index :compras_purchase_process_fractionations, :material_class_id,
              name: :cppf_material_class_idx
    # add_foreign_key :compras_purchase_process_fractionations,
    #                 :unico_material_classes,column: :material_class_id,
    #                 name: :cppf_material_class_fk
  end
end
