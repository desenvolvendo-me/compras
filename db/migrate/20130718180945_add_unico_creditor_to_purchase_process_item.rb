class AddUnicoCreditorToPurchaseProcessItem < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_items, :creditor_id, :integer

    add_index :compras_purchase_process_items, :creditor_id
    add_foreign_key :compras_purchase_process_items, :unico_creditors, column: :creditor_id
  end
end
