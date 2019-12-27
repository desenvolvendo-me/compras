class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :compras_expenses do |t|
      t.date :year
      t.references :organ
      t.references :purchasing_unit
      t.references :expense_function
      t.references :expense_sub_function
      t.references :program
      t.references :project_activity
      t.references :nature_expense
      t.references :resource_source
      t.integer :destiny
      t.string :destine_type

      t.timestamps
    end

    add_index :compras_expenses, :organ_id
    add_foreign_key :compras_expenses, :compras_organs, :column => :organ_id
    add_index :compras_expenses, :purchasing_unit_id
    add_foreign_key :compras_expenses, :compras_purchasing_units, :column => :purchasing_unit_id
    add_index :compras_expenses, :expense_function_id
    add_foreign_key :compras_expenses, :compras_expense_functions, :column => :expense_function_id
    add_index :compras_expenses, :expense_sub_function_id
    add_foreign_key :compras_expenses, :compras_expense_sub_functions, :column => :expense_sub_function_id
    add_index :compras_expenses, :program_id
    add_foreign_key :compras_expenses, :compras_programs, :column => :program_id
    add_index :compras_expenses, :project_activity_id
    add_foreign_key :compras_expenses, :compras_project_activities, :column => :project_activity_id
    add_index :compras_expenses, :nature_expense_id
    add_foreign_key :compras_expenses, :compras_nature_expenses, :column => :nature_expense_id
    add_index :compras_expenses, :resource_source_id
    add_foreign_key :compras_expenses, :compras_resource_sources, :column => :resource_source_id

  end
end