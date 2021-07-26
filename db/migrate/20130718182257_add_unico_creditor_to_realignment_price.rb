class AddUnicoCreditorToRealignmentPrice < ActiveRecord::Migration
  def change
    add_column :compras_realignment_prices, :creditor_id, :integer

    add_index :compras_realignment_prices, :creditor_id
    add_foreign_key :compras_realignment_prices, :unico_creditors, column: :creditor_id
  end
end
