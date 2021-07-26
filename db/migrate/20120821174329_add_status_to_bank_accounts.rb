class AddStatusToBankAccounts < ActiveRecord::Migration
  class BankAccount < Compras::Model
  end

  def change
    add_column :compras_bank_accounts, :status, :string
    BankAccount.update_all(:status => 'active')
  end
end
