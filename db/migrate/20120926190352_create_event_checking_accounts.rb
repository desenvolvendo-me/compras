class CreateEventCheckingAccounts < ActiveRecord::Migration
  def change
    create_table :compras_event_checking_accounts do |t|
      t.references :checking_account_of_fiscal_account
      t.references :event_checking_configuration
      t.string :nature_release
      t.string :operation

      t.timestamps
    end

    add_index :compras_event_checking_accounts,
              :event_checking_configuration_id,
              :name => :index_compras_event_checking_accounts_on_ecc_id
    add_index :compras_event_checking_accounts,
              :checking_account_of_fiscal_account_id,
              :name => :index_compras_event_checking_accounts_on_caofa_id

    add_foreign_key :compras_event_checking_accounts,
                    :compras_event_checking_configurations,
                    :column => :event_checking_configuration_id,
                    :name => :compras_event_checking_account_ecc_fk
    add_foreign_key :compras_event_checking_accounts,
                    :compras_checking_account_of_fiscal_accounts,
                    :column => :checking_account_of_fiscal_account_id,
                    :name => :compras_event_checking_account_caofa_fk
  end
end
