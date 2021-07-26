class CreateTableComprasBanks < ActiveRecord::Migration
  def change
    create_table "compras_banks" do |t|
      t.string   "name"
      t.string   "code"
      t.string   "acronym"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
