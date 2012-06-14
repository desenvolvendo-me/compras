class ReplaceBudgetStructureByCodeInBudgetStructure < ActiveRecord::Migration
  def up
    remove_column :compras_budget_structures, :budget_structure
    add_column :compras_budget_structures, :code, :integer
    add_column :compras_budget_structures, :budget_structure_level_id, :integer
    add_column :compras_budget_structures, :parent_id, :integer

    add_index :compras_budget_structures, :budget_structure_level_id
    add_index :compras_budget_structures, :parent_id
    add_foreign_key :compras_budget_structures, :compras_budget_structure_levels, :column => :budget_structure_level_id
    add_foreign_key :compras_budget_structures, :compras_budget_structures, :column => :parent_id
  end

  def down
    add_column :compras_budget_structures, :budget_structure, :integer
    remove_column :compras_budget_structures, :code
    remove_column :compras_budget_structures, :budget_structure_level_id
    remove_column :compras_budget_structures, :parent_id
  end
end
