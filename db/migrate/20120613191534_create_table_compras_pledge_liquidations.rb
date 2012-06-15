class CreateTableComprasPledgeLiquidations < ActiveRecord::Migration
  def change
    create_table "compras_pledge_liquidations" do |t|
      t.integer  "pledge_id"
      t.decimal  "value",       :precision => 10, :scale => 2
      t.date     "date"
      t.datetime "created_at",                                 :null => false
      t.datetime "updated_at",                                 :null => false
      t.text     "description"
    end

    add_index "compras_pledge_liquidations", ["pledge_id"], :name => "cpl_pledge_id"
  end
end
