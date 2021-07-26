class ChangeBankAccountsDigitToString < ActiveRecord::Migration
  def change
    change_column :compras_bank_accounts, :digit, :string
  end
end
