class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :neighborhood
      t.references :street
      t.references :district
      t.references :land_subdivision
      t.references :condominium
      t.string :complement
      t.references :addressable, :polymorphic => true

      t.timestamps
    end
    add_index :addresses, :neighborhood_id
    add_index :addresses, :street_id
    add_index :addresses, :district_id
    add_index :addresses, :land_subdivision_id
    add_index :addresses, :condominium_id
    add_index :addresses, :addressable_id

    add_foreign_key :addresses, :neighborhoods
    add_foreign_key :addresses, :streets
    add_foreign_key :addresses, :districts
    add_foreign_key :addresses, :land_subdivisions
    add_foreign_key :addresses, :condominiums
  end
end
