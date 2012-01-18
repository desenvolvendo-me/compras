class RemoveColumnPrefecturesAcronym < ActiveRecord::Migration
  def change
    remove_column :prefectures, :acronym
  end
end
