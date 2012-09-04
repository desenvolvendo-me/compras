class RenameCheckountAccountOfFiscalAccountsToCheckingAccountOfFiscalAccounts < ActiveRecord::Migration
  def change
    rename_table :compras_checkount_account_of_fiscal_accounts, :compras_checking_account_of_fiscal_accounts
  end
end
