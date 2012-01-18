class CreateMovementEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table :movement_economic_registrations do |t|
      t.references :economic_registration
      t.string :movement_sequency
      t.string :requiment_number
      t.references :type_movement_economic_registration
      t.text :description

      t.timestamps
    end
    add_index :movement_economic_registrations, :economic_registration_id, :name => 'economic_registration_idx'
    add_index :movement_economic_registrations, :type_movement_economic_registration_id, :name => 'type_movement_economic_registration_idx'
    add_foreign_key :movement_economic_registrations, :economic_registrations, :name => 'economic_registrations_fk'
    add_foreign_key :movement_economic_registrations, :type_movement_economic_registrations, :name => 'type_movement_economic_registrations_fk'
  end
end
