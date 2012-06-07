class DropSubpledgesTable < ActiveRecord::Migration
  def change
    drop_table :subpledges
  end
end
