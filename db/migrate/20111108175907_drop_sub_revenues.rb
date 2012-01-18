class DropSubRevenues < ActiveRecord::Migration
  def change
    drop_table :sub_revenues
  end
end
