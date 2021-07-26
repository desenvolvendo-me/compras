class CreateTableComprasSpecialEntries < ActiveRecord::Migration
  def change
    create_table "compras_special_entries" do |t|
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
