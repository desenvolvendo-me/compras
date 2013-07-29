class RemoveCreditorBankAccount < ActiveRecord::Migration
  def change
    drop_table :compras_creditor_bank_accounts
  end
end
