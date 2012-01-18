class RemoveZipCodeFromPrefectures < ActiveRecord::Migration
  def up
    remove_column :prefectures, :zip_code
  end

  def down
    add_column :prefectures, :zip_code, :string
  end
end
