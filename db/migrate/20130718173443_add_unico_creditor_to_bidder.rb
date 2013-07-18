class AddUnicoCreditorToBidder < ActiveRecord::Migration
  def change
    add_column :compras_bidders, :creditor_id, :integer

    add_index :compras_bidders, :creditor_id
    add_foreign_key :compras_bidders, :unico_creditors, column: :creditor_id
  end
end
