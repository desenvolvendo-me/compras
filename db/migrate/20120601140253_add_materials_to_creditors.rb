class AddMaterialsToCreditors < ActiveRecord::Migration
  def change
    create_table :creditor_materials do |t|
      t.integer :creditor_id
      t.integer :material_id
    end

    add_index :creditor_materials, :creditor_id
    add_index :creditor_materials, :material_id

    add_foreign_key :creditor_materials, :creditors
    add_foreign_key :creditor_materials, :materials
  end
end
