class CreateTableComprasBankAccounts < ActiveRecord::Migration
  def change
    create_table "compras_bank_accounts" do |t|
      t.string   "name"
      t.integer  "agency_id"
      t.string   "account_number"
      t.string   "originator"
      t.string   "number_agreement"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "compras_bank_accounts", ["agency_id"], :name => "cba_agency_id"
  end
end
