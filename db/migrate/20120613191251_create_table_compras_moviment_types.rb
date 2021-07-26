class CreateTableComprasMovimentTypes < ActiveRecord::Migration
  def change
    create_table "compras_moviment_types" do |t|
      t.string   "name"
      t.string   "operation"
      t.string   "character"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
