class RemoveBankAccount < ActiveRecord::Migration
  def change
    drop_table :compras_bank_accounts
  end
end
