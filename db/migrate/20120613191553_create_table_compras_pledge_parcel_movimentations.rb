class CreateTableComprasPledgeParcelMovimentations < ActiveRecord::Migration
  def change
    create_table "compras_pledge_parcel_movimentations" do |t|
      t.integer  "pledge_parcel_id"
      t.string   "pledge_parcel_modifiable_type"
      t.integer  "pledge_parcel_modifiable_id"
      t.decimal  "pledge_parcel_value_was",       :precision => 10, :scale => 2
      t.decimal  "pledge_parcel_value",           :precision => 10, :scale => 2
      t.decimal  "value",                         :precision => 10, :scale => 2
      t.datetime "created_at",                                                   :null => false
      t.datetime "updated_at",                                                   :null => false
    end

    add_index "compras_pledge_parcel_movimentations", ["pledge_parcel_id"], :name => "cppm_pledge_parcel_id"
  end
end
