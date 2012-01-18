class CreateBookmarks < ActiveRecord::Migration
  def up
    create_table :bookmarks do |t|
      t.integer :user_id
    end

    add_index :bookmarks, :user_id, :unique => true
    add_foreign_key :bookmarks, :users
  end

  def down
    drop_table :bookmarks
  end
end
