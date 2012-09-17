class AddFieldsToAccountPlan < ActiveRecord::Migration
  def change
    add_column :compras_account_plans, :checking_account_of_fiscal_account_id, :integer
    add_column :compras_account_plans, :ends_at_twelfth_month, :boolean, :default => false
    add_column :compras_account_plans, :ends_at_thirteenth_month, :boolean, :default => false
    add_column :compras_account_plans, :ends_at_fourteenth_month, :boolean, :default => false
    add_column :compras_account_plans, :does_not_ends, :boolean, :default => false
    add_column :compras_account_plans, :detailing_required_opening, :boolean, :default => false
    add_column :compras_account_plans, :detailing_required_thirteenth, :boolean, :default => false
    add_column :compras_account_plans, :detailing_required_fourteenth, :boolean, :default => false

    add_foreign_key :compras_account_plans, :compras_checking_account_of_fiscal_accounts,
                    :column => :checking_account_of_fiscal_account_id, :name => :cap_ccaofa_fk

    add_index :compras_account_plans, :checking_account_of_fiscal_account_id, :name => :cap_caofa_id
  end
end
