class RemoveComplementFromPrefectures < ActiveRecord::Migration
  def up
    remove_column :prefectures, :complement
  end

  def down
    add_column :prefectures, :complement, :string
  end
end
