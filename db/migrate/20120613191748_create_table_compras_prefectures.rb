class CreateTableComprasPrefectures < ActiveRecord::Migration
  def change
    create_table "compras_prefectures" do |t|
      t.string   "name"
      t.string   "cnpj"
      t.string   "phone"
      t.string   "fax"
      t.string   "email"
      t.string   "mayor_name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "image"
    end
  end
end
