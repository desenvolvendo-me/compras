class CreateTableComprasCurrencies < ActiveRecord::Migration
  def change
    create_table "compras_currencies" do |t|
      t.string   "name"
      t.string   "acronym"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
