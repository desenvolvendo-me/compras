class AddLandSubdivisionToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :land_subdivision, :string
  end
end
