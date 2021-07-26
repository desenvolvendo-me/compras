class RemoveEntityIdAndYear < ActiveRecord::Migration
  def change
    remove_column :compras_budget_allocations, :entity_id
    remove_column :compras_budget_allocations, :year

    remove_column :compras_capabilities, :entity_id
    remove_column :compras_capabilities, :year

    remove_column :compras_expense_natures, :entity_id
    remove_column :compras_expense_natures, :year

    remove_column :compras_extra_credits, :entity_id
    remove_column :compras_extra_credits, :year

    remove_column :compras_government_actions, :entity_id
    remove_column :compras_government_actions, :year

    remove_column :compras_government_programs, :entity_id
    remove_column :compras_government_programs, :year

    remove_column :compras_management_units, :entity_id
    remove_column :compras_management_units, :year

    remove_column :compras_pledge_historics, :entity_id
    remove_column :compras_pledge_historics, :year

    remove_column :compras_pledges, :entity_id
    remove_column :compras_pledges, :year

    remove_column :compras_reserve_funds, :entity_id
    remove_column :compras_reserve_funds, :year

    remove_column :compras_revenue_accountings, :entity_id
    remove_column :compras_revenue_accountings, :year

    remove_column :compras_revenue_natures, :entity_id
    remove_column :compras_revenue_natures, :year

    remove_column :compras_subfunctions, :entity_id
    remove_column :compras_subfunctions, :year
  end
end
