class RemoveStreetIdFromPrefectures < ActiveRecord::Migration
  def up
    remove_column :prefectures, :street_id
  end

  def down
    add_column :prefectures, :street_id, :integer
    add_index :prefectures, :street_id
    add_foreign_key :prefectures, :streets
  end
end
