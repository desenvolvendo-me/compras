class AddPrefectureIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prefecture_id, :integer
    add_index :users, :prefecture_id
    add_foreign_key :users, :prefectures
  end
end
