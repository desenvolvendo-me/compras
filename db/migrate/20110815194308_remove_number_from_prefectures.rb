class RemoveNumberFromPrefectures < ActiveRecord::Migration
  def up
    remove_column :prefectures, :number
  end

  def down
    add_column :prefectures, :number, :integer
  end
end
