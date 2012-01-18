class AddLftAndRgtToCnaes < ActiveRecord::Migration
  def change
    add_column :cnaes, :lft, :integer
    add_column :cnaes, :rgt, :integer
  end
end
