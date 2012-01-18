class RemoveRevenueIdFromBankAccounts < ActiveRecord::Migration
  def change
    remove_foreign_key :bank_accounts, :revenues
    remove_index :bank_accounts, :revenue_id
    remove_column :bank_accounts, :revenue_id
  end
end
