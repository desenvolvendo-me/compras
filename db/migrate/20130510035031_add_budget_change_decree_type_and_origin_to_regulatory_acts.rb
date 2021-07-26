class AddBudgetChangeDecreeTypeAndOriginToRegulatoryActs < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_acts, :budget_change_decree_type, :string
    add_column :compras_regulatory_acts, :budget_change_law_type, :string
    add_column :compras_regulatory_acts, :origin, :string
  end
end
