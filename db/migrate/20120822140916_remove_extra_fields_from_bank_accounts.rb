class RemoveExtraFieldsFromBankAccounts < ActiveRecord::Migration
  def change
    remove_column :compras_bank_accounts, :originator
    remove_column :compras_bank_accounts, :number_agreement
  end
end
