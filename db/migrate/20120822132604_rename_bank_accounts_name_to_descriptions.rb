class RenameBankAccountsNameToDescriptions < ActiveRecord::Migration
  def change
    rename_column :compras_bank_accounts, :name, :description
  end
end
