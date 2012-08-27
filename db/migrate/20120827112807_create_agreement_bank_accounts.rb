class CreateAgreementBankAccounts < ActiveRecord::Migration
  def change
    create_table "compras_agreement_bank_accounts" do |t|
      t.integer    "agreement_id"
      t.integer    "bank_account_id"
      t.date       "creation_date"
      t.date       "desactivation_date"
      t.string     "status"
      t.timestamps
    end

    add_index :compras_agreement_bank_accounts, :agreement_id
    add_index :compras_agreement_bank_accounts, :bank_account_id

    add_foreign_key :compras_agreement_bank_accounts, :compras_agreements,
                    :column => :agreement_id
    add_foreign_key :compras_agreement_bank_accounts, :compras_bank_accounts,
                    :column => :bank_account_id
  end
end
