class MigrateBudgetStructureResponsibles < ActiveRecord::Migration
  def change
    BudgetStructure.find_each do |structure|
      count = structure.budget_structure_responsibles.count

      structure.budget_structure_responsibles.each_with_index do |responsible, index|
        next if index.succ == count

        responsible.destroy
      end
    end
  end
end
