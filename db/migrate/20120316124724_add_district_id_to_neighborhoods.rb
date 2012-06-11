class AddDistrictIdToNeighborhoods < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :district_id, :integer
    add_index  :neighborhoods, :district_id
    add_foreign_key :neighborhoods, :districts
  end
end
