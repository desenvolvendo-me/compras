class RemoveCancelledFromFiscalExecutionActiveDebts < ActiveRecord::Migration
  def change
    remove_column :fiscal_execution_active_debts, :cancelled
  end
end
