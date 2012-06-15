class CreateTableComprasPledgeParcels < ActiveRecord::Migration
  def change
    create_table "compras_pledge_parcels" do |t|
      t.date     "expiration_date"
      t.decimal  "value"
      t.integer  "pledge_id"
      t.integer  "number"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "compras_pledge_parcels", ["pledge_id"], :name => "cpp_pledge_id"
  end
end
