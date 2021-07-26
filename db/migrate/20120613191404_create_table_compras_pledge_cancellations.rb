class CreateTableComprasPledgeCancellations < ActiveRecord::Migration
  def change
    create_table "compras_pledge_cancellations" do |t|
      t.integer  "pledge_id"
      t.decimal  "value",      :precision => 10, :scale => 2
      t.date     "date"
      t.string   "nature"
      t.text     "reason"
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
    end

    add_index "compras_pledge_cancellations", ["pledge_id"], :name => "cpc_pledge_id"
  end
end
