class CreateBankAccountResources < ActiveRecord::Migration
  def change
    create_table :compras_bank_account_capabilities do |t|
      t.references :bank_account
      t.references :capability
      t.date :date
      t.date :inactivation_date
      t.string :status

      t.timestamps
    end

    add_index :compras_bank_account_capabilities, :bank_account_id
    add_index :compras_bank_account_capabilities, :capability_id

    add_foreign_key :compras_bank_account_capabilities, :compras_bank_accounts,
                    :column => :bank_account_id, :name => :cbar_cba_fk
    add_foreign_key :compras_bank_account_capabilities, :compras_capabilities,
                    :column => :capability_id, :name => :cbar_cc_fk
  end
end
