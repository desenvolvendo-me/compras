class RemovePrefectureIdFromStreets < ActiveRecord::Migration
  def up
    remove_column :streets, :prefecture_id
  end

  def down
    add_column :streets, :prefecture_id, :integer
    add_index :streets, :prefecture_id
    add_foreign_key :streets, :prefectures
  end
end
