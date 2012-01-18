class RemoveNeighboordIdFromLandSubdivisions < ActiveRecord::Migration
  def change
    remove_column :land_subdivisions, :neighborhood_id
  end
end
