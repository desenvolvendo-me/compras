class CreateTableComprasBookmarks < ActiveRecord::Migration
  def change
    create_table "compras_bookmarks" do |t|
      t.integer "user_id"
    end

    add_index "compras_bookmarks", ["user_id"], :name => "cb_user_id"
  end
end
