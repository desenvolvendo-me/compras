class CreateBookmarksLinks < ActiveRecord::Migration
  def up
    create_table :bookmarks_links, :id => false do |t|
      t.integer :bookmark_id
      t.integer :link_id
    end

    add_foreign_key :bookmarks_links, :bookmarks
    add_foreign_key :bookmarks_links, :links

    add_index :bookmarks_links, :bookmark_id
    add_index :bookmarks_links, :link_id
  end

  def down
    drop_table :bookmarks_links
  end
end
