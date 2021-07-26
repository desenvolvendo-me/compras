class CreatePurchaseProcessFractionation < ActiveRecord::Migration
  def change

    create_table :compras_purchase_process_fractionations do |t|
      t.integer :year
      t.integer :material_class_id
      t.integer :purchase_process_id
      t.decimal :value, precision: 10, scale: 2, default: 0.0
      t.string  :object_type
      t.string  :modality
      t.string  :type_of_removal
    end

    add_index :compras_purchase_process_fractionations, :material_class_id,
      name: :cppf_material_class_idx
    add_index :compras_purchase_process_fractionations, :purchase_process_id,
      name: :cppf_purchase_process_idx

    add_foreign_key :compras_purchase_process_fractionations, :compras_material_classes,
      column: :material_class_id, name: :cmcl_material_class_fk
    add_foreign_key :compras_purchase_process_fractionations, :compras_licitation_processes,
      column: :purchase_process_id, name: :cmcl_purchase_process_fk
  end
end
