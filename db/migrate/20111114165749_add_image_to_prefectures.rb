class AddImageToPrefectures < ActiveRecord::Migration
  def change
    add_column :prefectures, :image, :string
  end
end
