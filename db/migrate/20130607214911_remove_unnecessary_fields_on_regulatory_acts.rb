class RemoveUnnecessaryFieldsOnRegulatoryActs < ActiveRecord::Migration
  def change
    remove_column :compras_regulatory_acts, :regulatory_act_type_id
    remove_column :compras_regulatory_acts, :budget_law_percent
    remove_column :compras_regulatory_acts, :revenue_antecipation_percent
    remove_column :compras_regulatory_acts, :authorized_debt_value
  end
end
