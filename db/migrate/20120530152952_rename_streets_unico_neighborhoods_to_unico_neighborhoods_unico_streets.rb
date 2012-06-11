class RenameStreetsUnicoNeighborhoodsToUnicoNeighborhoodsUnicoStreets < ActiveRecord::Migration
  def change
    rename_table :streets_unico_neighborhoods, :unico_neighborhoods_unico_streets
  end
end
