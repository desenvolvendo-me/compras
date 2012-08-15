class CreateCapabilityDestinations < ActiveRecord::Migration
  def change
    create_table :compras_capability_destinations do |t|
      t.string :capability_destination_use
      t.string :capability_destination_group
      t.integer :specification
      t.string :description
      t.string :destination

      t.timestamps
    end
  end
end
