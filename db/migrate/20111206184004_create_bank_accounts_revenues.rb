class CreateBankAccountsRevenues < ActiveRecord::Migration
  def change
    create_table :bank_accounts_revenues, :id => false do |t|
      t.references :bank_account
      t.references :revenue
    end
    add_index :bank_accounts_revenues, :bank_account_id
    add_index :bank_accounts_revenues, :revenue_id
    add_foreign_key :bank_accounts_revenues, :bank_accounts
    add_foreign_key :bank_accounts_revenues, :revenues
  end
end
