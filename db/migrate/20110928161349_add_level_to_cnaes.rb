class AddLevelToCnaes < ActiveRecord::Migration
  def change
    add_column :cnaes, :level, :integer
  end
end
