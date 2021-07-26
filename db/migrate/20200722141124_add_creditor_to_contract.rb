class AddCreditorToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :creditor_id, :integer

    add_index :compras_contracts, :creditor_id
    add_foreign_key :compras_contracts, :unico_creditors, column: :creditor_id
  end
end
