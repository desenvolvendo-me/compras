class RemoveDistrictIdFromLandSubdivisions < ActiveRecord::Migration
  def change
    remove_column :land_subdivisions, :district_id
  end
end
