class ReplaceBudgetStructureByCodeInBudgetStructure < ActiveRecord::Migration
  def up
    remove_column :budget_structures, :budget_structure
    add_column :budget_structures, :code, :integer
    add_column :budget_structures, :budget_structure_level_id, :integer
    add_column :budget_structures, :parent_id, :integer

    add_index :budget_structures, :budget_structure_level_id
    add_index :budget_structures, :parent_id
    add_foreign_key :budget_structures, :budget_structure_levels, :column => :budget_structure_level_id
    add_foreign_key :budget_structures, :budget_structures, :column => :parent_id
  end

  def down
    add_column :budget_structures, :budget_structure, :integer
    remove_column :budget_structures, :code
    remove_column :budget_structures, :budget_structure_level_id
    remove_column :budget_structures, :parent_id
  end
end
