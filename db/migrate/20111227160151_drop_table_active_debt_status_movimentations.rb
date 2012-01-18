class DropTableActiveDebtStatusMovimentations < ActiveRecord::Migration
  def change
    drop_table :active_debt_status_movimentations
  end
end
