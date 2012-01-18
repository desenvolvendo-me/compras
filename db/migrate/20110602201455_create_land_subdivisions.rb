class CreateLandSubdivisions < ActiveRecord::Migration
  def change
    create_table :land_subdivisions do |t|
      t.string :name
      t.references :neighborhood
      t.references :district

      t.timestamps
    end
    add_index :land_subdivisions, :neighborhood_id
    add_index :land_subdivisions, :district_id
    add_foreign_key :land_subdivisions, :neighborhoods
    add_foreign_key :land_subdivisions, :districts
  end
end
