class CreateTablePurchaseSolicitationBudgetary < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_budgetaries do |t|
      t.integer :purchase_solicitation_id
      t.integer :expense_id
      t.integer :secretary_id
      t.decimal :value, precision: 15, scale: 2

      t.timestamps
    end

    add_index :compras_purchase_solicitation_budgetaries, :purchase_solicitation_id, name: :budgetary_licitation_process_index
    add_foreign_key :compras_purchase_solicitation_budgetaries, :compras_purchase_solicitations,
                    column: :purchase_solicitation_id, name: :budgetary_purchase_solicitation_fk

    add_index :compras_purchase_solicitation_budgetaries, :expense_id, name: :budgetary_expense_index
    add_foreign_key :compras_purchase_solicitation_budgetaries, :compras_expenses,
                    column: :expense_id, name: :budgetary_expense_fk

    add_index :compras_purchase_solicitation_budgetaries, :secretary_id, name: :budgetary_secretary_index
    add_foreign_key :compras_purchase_solicitation_budgetaries, :compras_secretaries,
                    column: :secretary_id, name: :budgetary_secretary_fk
  end
end
