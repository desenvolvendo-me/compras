class CreateTableComprasCreditorBankAccounts < ActiveRecord::Migration
  def change
    create_table "compras_creditor_bank_accounts" do |t|
      t.integer "creditor_id"
      t.integer "agency_id"
      t.string  "status"
      t.string  "account_type"
      t.string  "number"
      t.string  "digit"
    end

    add_index "compras_creditor_bank_accounts", ["agency_id", "number"], :name => "ccba_number", :unique => true
    add_index "compras_creditor_bank_accounts", ["agency_id"], :name => "ccba_agency_id"
    add_index "compras_creditor_bank_accounts", ["creditor_id"], :name => "ccba_creditor_id"
  end
end
