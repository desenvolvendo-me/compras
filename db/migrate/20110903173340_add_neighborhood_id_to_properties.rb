class AddNeighborhoodIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :neighborhood_id, :integer
    add_index :properties, :neighborhood_id
  end
end
