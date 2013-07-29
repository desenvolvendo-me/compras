class AddUnicoCreditorToCreditorMaterial < ActiveRecord::Migration
  def change
    add_column :compras_creditor_materials, :creditor_id, :integer

    add_index :compras_creditor_materials, :creditor_id
    add_foreign_key :compras_creditor_materials, :unico_creditors, column: :creditor_id
  end
end
