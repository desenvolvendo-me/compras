class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.references :bank
      t.references :agency
      t.string :account_number
      t.string :originator
      t.string :number_agreement
      t.references :revenue

      t.timestamps
    end
    add_index :bank_accounts, :bank_id
    add_index :bank_accounts, :agency_id
    add_index :bank_accounts, :revenue_id
    add_foreign_key :bank_accounts, :banks
    add_foreign_key :bank_accounts, :agencies
    add_foreign_key :bank_accounts, :revenues
  end
end
