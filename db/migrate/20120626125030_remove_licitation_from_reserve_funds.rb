class RemoveLicitationFromReserveFunds < ActiveRecord::Migration
  def change
    remove_columns :compras_reserve_funds, :licitation_number, :licitation_year
  end
end
