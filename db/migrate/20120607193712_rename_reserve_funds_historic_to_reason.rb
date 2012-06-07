class RenameReserveFundsHistoricToReason < ActiveRecord::Migration
  def change
    rename_column :reserve_funds, :historic, :reason
  end
end
