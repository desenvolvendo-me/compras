class RemovePrefectureIdFromUsers < ActiveRecord::Migration
  def up
    remove_foreign_key :users, :prefectures
    remove_index :users, :prefecture_id
    remove_column :users, :prefecture_id
  end

  def down
    add_column :users, :prefecture_id, :integer
    add_index :users, :prefecture_id
    add_foreign_key :users, :prefectures
  end
end
