class AddPrecisionToFiscalExecutionDocumentsWithdrawValue < ActiveRecord::Migration
  def change
    change_column :fiscal_execution_documents, :withdraw_value, :decimal, :precision => 10, :scale => 2
  end
end
