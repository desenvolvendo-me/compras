class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.references :city

      t.timestamps
    end
    add_index :neighborhoods, :city_id
    add_foreign_key :neighborhoods, :cities
  end
end
