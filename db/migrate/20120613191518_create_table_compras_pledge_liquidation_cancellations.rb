class CreateTableComprasPledgeLiquidationCancellations < ActiveRecord::Migration
  def change
    create_table "compras_pledge_liquidation_cancellations" do |t|
      t.integer  "pledge_id"
      t.decimal  "value",      :precision => 10, :scale => 2
      t.date     "date"
      t.text     "reason"
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
    end

    add_index "compras_pledge_liquidation_cancellations", ["pledge_id"], :name => "cplc_pledge_id"
  end
end
