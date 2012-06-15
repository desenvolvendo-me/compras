class CreateTableComprasPositions < ActiveRecord::Migration
  def change
    create_table "compras_positions" do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
