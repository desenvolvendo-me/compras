class RenameLandSubdivisionsToUnicoLandSubdivisions < ActiveRecord::Migration
  def change
    rename_table :land_subdivisions, :unico_land_subdivisions
  end
end
