class CreateLicitationProcessBudgetaries < ActiveRecord::Migration
  def change
    create_table :compras_licitation_process_budgetaries do |t|
      t.integer :licitation_process_id
      t.integer :expense_id
      t.integer :secretary_id
      t.decimal :value, precision: 15, scale: 2

      t.timestamps
    end

    add_index :compras_licitation_process_budgetaries, :licitation_process_id, name: :budgetary_licitation_process_index
    add_foreign_key :compras_licitation_process_budgetaries, :compras_licitation_processes,
                    column: :licitation_process_id, name: :budgetary_licitation_process_fk

    add_index :compras_licitation_process_budgetaries, :expense_id, name: :budgetary_expense_index
    add_foreign_key :compras_licitation_process_budgetaries, :compras_expenses,
                    column: :expense_id, name: :budgetary_expense_fk

    add_index :compras_licitation_process_budgetaries, :secretary_id, name: :budgetary_secretary_index
    add_foreign_key :compras_licitation_process_budgetaries, :compras_secretaries,
                    column: :secretary_id, name: :budgetary_secretary_fk
  end
end
