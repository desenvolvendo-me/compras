class RemoveBankIdFromBankAccounts < ActiveRecord::Migration
  def change
    remove_index :bank_accounts, :bank_id
    remove_foreign_key :bank_accounts, :banks
    remove_column :bank_accounts, :bank_id
  end
end
