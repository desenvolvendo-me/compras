class CreateCreditorBankAccounts < ActiveRecord::Migration
  def change
    create_table :creditor_bank_accounts do |t|
      t.references :creditor
      t.references :agency
      t.string :status
      t.string :account_type
      t.string :number
      t.string :digit
    end

    add_index :creditor_bank_accounts, :creditor_id
    add_index :creditor_bank_accounts, :agency_id
    add_index :creditor_bank_accounts, [:agency_id, :number], :unique => true
    add_foreign_key :creditor_bank_accounts, :creditors
    add_foreign_key :creditor_bank_accounts, :agencies
  end
nend
