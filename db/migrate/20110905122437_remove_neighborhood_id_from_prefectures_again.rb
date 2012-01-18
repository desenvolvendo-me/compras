class RemoveNeighborhoodIdFromPrefecturesAgain < ActiveRecord::Migration
  def up
    remove_index :prefectures, :neighborhood_id
    remove_column :prefectures, :neighborhood_id
  end

  def down
    add_column :prefectures, :neighborhood_id, :integer
    add_index :prefectures, :neighborhood_id
  end
end
