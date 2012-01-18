class CreateFiscalExecutionActiveDebts < ActiveRecord::Migration
  def change
    create_table :fiscal_execution_active_debts do |t|
      t.references :fiscal_execution
      t.references :active_debt
      t.string :status
      t.boolean :cancelled, :default => false

      t.timestamps
    end
    add_index :fiscal_execution_active_debts, :fiscal_execution_id
    add_index :fiscal_execution_active_debts, :active_debt_id

    add_foreign_key :fiscal_execution_active_debts, :fiscal_executions
    add_foreign_key :fiscal_execution_active_debts, :active_debts
  end
end
