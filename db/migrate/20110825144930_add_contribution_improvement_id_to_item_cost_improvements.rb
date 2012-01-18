class AddContributionImprovementIdToItemCostImprovements < ActiveRecord::Migration
  def change
    add_column :item_cost_improvements, :contribution_improvement_id, :integer
    add_index :item_cost_improvements, :contribution_improvement_id
    add_foreign_key :item_cost_improvements, :contribution_improvements
  end
end
