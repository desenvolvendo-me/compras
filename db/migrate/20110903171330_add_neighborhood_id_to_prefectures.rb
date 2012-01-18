class AddNeighborhoodIdToPrefectures < ActiveRecord::Migration
  def change
    add_column :prefectures, :neighborhood_id, :integer
    add_index :prefectures, :neighborhood_id
  end
end
