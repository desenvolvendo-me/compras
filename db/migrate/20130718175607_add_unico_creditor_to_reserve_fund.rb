class AddUnicoCreditorToReserveFund < ActiveRecord::Migration
  def change
    add_column :compras_reserve_funds, :creditor_id, :integer

    add_index :compras_reserve_funds, :creditor_id
    add_foreign_key :compras_reserve_funds, :unico_creditors, column: :creditor_id
  end
end
