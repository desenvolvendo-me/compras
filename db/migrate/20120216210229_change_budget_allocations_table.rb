class ChangeBudgetAllocationsTable < ActiveRecord::Migration
  def change
    change_table :budget_allocations do |t|
      t.integer :entity_id
      t.integer :year
      t.integer :organogram_id
      t.integer :function_id
      t.integer :subfunction_id
      t.integer :government_program_id
      t.integer :government_action_id
      t.integer :expense_economic_classification_id
      t.integer :capability_id
      t.text :goal
      t.integer :debt_type
      t.integer :budget_allocation_type_id
      t.boolean :refinancing, :default => false
      t.boolean :health, :default => false
      t.boolean :alienation_appeal, :default => false
      t.boolean :education, :default => false
      t.boolean :foresight, :default => false
      t.boolean :personal, :default => false
      t.date :date
      t.decimal :value, :precision => 10, :scale => 2
    end

    add_index :budget_allocations, :entity_id
    add_index :budget_allocations, :organogram_id
    add_index :budget_allocations, :function_id
    add_index :budget_allocations, :subfunction_id
    add_index :budget_allocations, :government_program_id
    add_index :budget_allocations, :government_action_id
    add_index :budget_allocations, :expense_economic_classification_id
    add_index :budget_allocations, :capability_id
    add_index :budget_allocations, :budget_allocation_type_id

    add_foreign_key :budget_allocations, :entities
    add_foreign_key :budget_allocations, :organograms
    add_foreign_key :budget_allocations, :functions
    add_foreign_key :budget_allocations, :subfunctions
    add_foreign_key :budget_allocations, :government_programs
    add_foreign_key :budget_allocations, :government_actions
    add_foreign_key :budget_allocations, :expense_economic_classifications
    add_foreign_key :budget_allocations, :capabilities
    add_foreign_key :budget_allocations, :budget_allocation_types
  end
end
