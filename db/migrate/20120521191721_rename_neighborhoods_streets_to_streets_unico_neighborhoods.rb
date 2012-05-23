class RenameNeighborhoodsStreetsToStreetsUnicoNeighborhoods < ActiveRecord::Migration
  def change
    rename_table :neighborhoods_streets, :streets_unico_neighborhoods
  end
end
