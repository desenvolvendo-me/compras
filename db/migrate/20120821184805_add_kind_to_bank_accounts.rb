class AddKindToBankAccounts < ActiveRecord::Migration
  def change
    add_column :compras_bank_accounts, :kind, :string
  end
end
