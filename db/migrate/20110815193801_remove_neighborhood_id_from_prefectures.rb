class RemoveNeighborhoodIdFromPrefectures < ActiveRecord::Migration
  def up
    remove_column :prefectures, :neighborhood_id
  end

  def down
    add_column :prefectures, :neighborhood_id, :integer
    add_index :prefectures, :neighborhood_id
    add_foreign_key :prefecures, :neighborhoods
  end
end
