class CreateTableComprasPrecatoryParcels < ActiveRecord::Migration
  def change
    create_table "compras_precatory_parcels" do |t|
      t.integer "precatory_id"
      t.date    "expiration_date"
      t.decimal "value",           :precision => 10, :scale => 2
      t.string  "situation"
      t.date    "payment_date"
      t.decimal "amount_paid",     :precision => 10, :scale => 2
      t.string  "observation"
    end

    add_index "compras_precatory_parcels", ["precatory_id"], :name => "cpp_precatory_id"
  end
end
