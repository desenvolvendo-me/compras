class AddPrefecturyIdToStreets < ActiveRecord::Migration
  def change
    add_column :streets, :prefecture_id, :integer
    add_index :streets, :prefecture_id
    add_foreign_key :streets, :prefectures
  end
end
