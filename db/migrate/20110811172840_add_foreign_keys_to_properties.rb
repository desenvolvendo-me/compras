class AddForeignKeysToProperties < ActiveRecord::Migration
  def change
    add_foreign_key :properties, :people, :column => :co_owner_id
    add_foreign_key :properties, :charging_types
    add_foreign_key :properties, :neighborhoods
    add_foreign_key :properties, :districts
    add_foreign_key :properties, :land_subdivisions
    add_foreign_key :properties, :section_streets
    add_foreign_key :properties, :side_section_streets
    add_foreign_key :properties, :address_tickets
  end
end
