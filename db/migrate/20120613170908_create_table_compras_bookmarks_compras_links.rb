class CreateTableComprasBookmarksComprasLinks < ActiveRecord::Migration
  def change
    create_table "compras_bookmarks_compras_links", :id => false do |t|
      t.integer "bookmark_id"
      t.integer "link_id"
    end

    add_index "compras_bookmarks_compras_links", ["bookmark_id"], :name => "cbcl_bookmark_id"
    add_index "compras_bookmarks_compras_links", ["link_id"], :name => "cbcl_link_id"
  end
end
