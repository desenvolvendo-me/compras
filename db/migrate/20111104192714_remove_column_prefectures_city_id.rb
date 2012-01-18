class RemoveColumnPrefecturesCityId < ActiveRecord::Migration
  def change
    remove_column :prefectures, :city_id
  end
end
