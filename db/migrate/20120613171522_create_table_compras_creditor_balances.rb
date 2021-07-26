class CreateTableComprasCreditorBalances < ActiveRecord::Migration
  def change
    create_table "compras_creditor_balances" do |t|
      t.integer "creditor_id"
      t.integer "fiscal_year"
      t.decimal "current_assets",          :precision => 10, :scale => 2
      t.decimal "long_term_assets",        :precision => 10, :scale => 2
      t.decimal "current_liabilities",     :precision => 10, :scale => 2
      t.decimal "net_equity",              :precision => 10, :scale => 2
      t.decimal "long_term_liabilities",   :precision => 10, :scale => 2
      t.decimal "liquidity_ratio_general", :precision => 10, :scale => 2
      t.decimal "current_radio",           :precision => 10, :scale => 2
      t.decimal "net_working_capital",     :precision => 10, :scale => 2
    end

    add_index "compras_creditor_balances", ["creditor_id"], :name => "ccb_creditor_id"
  end
end
