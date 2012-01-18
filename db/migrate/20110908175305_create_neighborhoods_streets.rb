class CreateNeighborhoodsStreets < ActiveRecord::Migration
  def change
    create_table :neighborhoods_streets, :id => false do |t|
      t.references :street, :neighborhood
    end

    add_index :neighborhoods_streets, :street_id
    add_index :neighborhoods_streets, :neighborhood_id
    add_index :neighborhoods_streets, [:street_id, :neighborhood_id], :unique => true, :name => :street_neighborhood
    add_foreign_key :neighborhoods_streets, :streets
    add_foreign_key :neighborhoods_streets, :neighborhoods
  end
end
