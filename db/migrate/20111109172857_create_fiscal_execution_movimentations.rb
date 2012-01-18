class CreateFiscalExecutionMovimentations < ActiveRecord::Migration
  def change
    create_table :fiscal_execution_movimentations do |t|
      t.text :observations
      t.integer :fiscal_execution_id
      t.string :type_of_movimentation
      t.string :status_of_movimentation
      t.string :process_number

      t.timestamps
    end
    
    add_index :fiscal_execution_movimentations, :fiscal_execution_id
    add_foreign_key :fiscal_execution_movimentations, :fiscal_executions
  end
end
