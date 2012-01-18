class CreateCondominiums < ActiveRecord::Migration
  def change
    create_table :condominiums do |t|
      t.references :street
      t.references :neighborhood
      t.references :condominium_type
      t.string :name
      t.integer :number
      t.integer :quantity_garages
      t.integer :quantity_units
      t.integer :quantity_blocks
      t.integer :quantity_elevators
      t.integer :quantity_rooms
      t.integer :quantity_floors
      t.decimal :built_area
      t.decimal :area_common_user
      t.integer :construction_year

      t.timestamps
    end
    add_index :condominiums, :street_id
    add_index :condominiums, :neighborhood_id
    add_index :condominiums, :condominium_type_id

    add_foreign_key :condominiums, :condominium_types
    add_foreign_key :condominiums, :neighborhoods
    add_foreign_key :condominiums, :streets
  end
end
