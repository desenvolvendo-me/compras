class AddBankAccountIdToLowerPayments < ActiveRecord::Migration
  def change
    add_column :lower_payments, :bank_account_id, :integer
    add_index :lower_payments, :bank_account_id
    add_foreign_key :lower_payments, :bank_accounts
  end
end
