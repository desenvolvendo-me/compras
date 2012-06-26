class RemoveProcessFromReserveFunds < ActiveRecord::Migration
  def change
    remove_columns :compras_reserve_funds, :process_number, :process_year
  end
end
