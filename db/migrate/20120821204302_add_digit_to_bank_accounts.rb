class AddDigitToBankAccounts < ActiveRecord::Migration
  def change
    add_column :compras_bank_accounts, :digit, :integer
  end
end
