class AddProcessYearIndexToBidOpening < ActiveRecord::Migration
  def change
    add_index :bid_openings, [:process, :year], :unique => true
  end
end
