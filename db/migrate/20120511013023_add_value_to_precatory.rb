class AddValueToPrecatory < ActiveRecord::Migration
  def change
    add_column :precatories, :value, :decimal, :precision => 10, :scale => 2
  end
end
