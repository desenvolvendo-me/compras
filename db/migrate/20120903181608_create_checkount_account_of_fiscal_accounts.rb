class CreateCheckountAccountOfFiscalAccounts < ActiveRecord::Migration
  def change
    create_table :compras_checkount_account_of_fiscal_accounts do |t|
      t.integer :tce_code
      t.string :name
      t.string :main_tag
      t.text :function

      t.timestamps
    end
  end
end
