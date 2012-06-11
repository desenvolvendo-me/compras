class CreateUnicoNeighborhoods < ActiveRecord::Migration
  def change
    rename_table :neighborhoods, :unico_neighborhoods
  end
end
