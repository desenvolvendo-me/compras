class AddDescriptorRelation < ActiveRecord::Migration
  def change
    add_column :compras_budget_allocations, :descriptor_id, :integer
    add_index :compras_budget_allocations, :descriptor_id
    add_foreign_key :compras_budget_allocations, :compras_descriptors, :column => :descriptor_id

    add_column :compras_capabilities, :descriptor_id, :integer
    add_index :compras_capabilities, :descriptor_id
    add_foreign_key :compras_capabilities, :compras_descriptors, :column => :descriptor_id

    add_column :compras_expense_natures, :descriptor_id, :integer
    add_index :compras_expense_natures, :descriptor_id
    add_foreign_key :compras_expense_natures, :compras_descriptors, :column => :descriptor_id

    add_column :compras_extra_credits, :descriptor_id, :integer
    add_index :compras_extra_credits, :descriptor_id
    add_foreign_key :compras_extra_credits, :compras_descriptors, :column => :descriptor_id

    add_column :compras_government_actions, :descriptor_id, :integer
    add_index :compras_government_actions, :descriptor_id
    add_foreign_key :compras_government_actions, :compras_descriptors, :column => :descriptor_id

    add_column :compras_government_programs, :descriptor_id, :integer
    add_index :compras_government_programs, :descriptor_id
    add_foreign_key :compras_government_programs, :compras_descriptors, :column => :descriptor_id

    add_column :compras_management_units, :descriptor_id, :integer
    add_index :compras_management_units, :descriptor_id
    add_foreign_key :compras_management_units, :compras_descriptors, :column => :descriptor_id

    add_column :compras_pledge_historics, :descriptor_id, :integer
    add_index :compras_pledge_historics, :descriptor_id
    add_foreign_key :compras_pledge_historics, :compras_descriptors, :column => :descriptor_id

    add_column :compras_pledges, :descriptor_id, :integer
    add_index :compras_pledges, :descriptor_id
    add_foreign_key :compras_pledges, :compras_descriptors, :column => :descriptor_id

    add_column :compras_reserve_funds, :descriptor_id, :integer
    add_index :compras_reserve_funds, :descriptor_id
    add_foreign_key :compras_reserve_funds, :compras_descriptors, :column => :descriptor_id

    add_column :compras_revenue_accountings, :descriptor_id, :integer
    add_index :compras_revenue_accountings, :descriptor_id
    add_foreign_key :compras_revenue_accountings, :compras_descriptors, :column => :descriptor_id

    add_column :compras_revenue_natures, :descriptor_id, :integer
    add_index :compras_revenue_natures, :descriptor_id
    add_foreign_key :compras_revenue_natures, :compras_descriptors, :column => :descriptor_id

    add_column :compras_subfunctions, :descriptor_id, :integer
    add_index :compras_subfunctions, :descriptor_id
    add_foreign_key :compras_subfunctions, :compras_descriptors, :column => :descriptor_id
  end
end
