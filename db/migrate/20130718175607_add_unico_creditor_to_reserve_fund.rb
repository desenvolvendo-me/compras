class AddUnicoCreditorToReserveFund < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_reserve_funds
      add_column :compras_reserve_funds, :creditor_id, :integer

      add_index :compras_reserve_funds, :creditor_id
      add_foreign_key :compras_reserve_funds, :unico_creditors, column: :creditor_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
