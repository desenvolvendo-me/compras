class CreateEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table :economic_registrations do |t|
      t.string :registration
      t.references :person
      t.references :branch_classification
      t.references :issqn_classification
      t.references :branch_activity
      t.references :cnae
      t.references :list_service
      t.boolean :location_operation_fee, :default => false
      t.boolean :special_schedule_fee, :default => false
      t.boolean :publicity_fee, :default => false
      t.boolean :sanitary_permit_fee, :default => false
      t.boolean :land_use_fee, :default => true
      t.references :working_hour
      t.references :accountant
      t.references :street
      t.integer :number
      t.text :complement
      t.references :neighborhood
      t.references :district
      t.references :city
      t.references :state
      t.string :zip_code
      t.references :condominium
      t.string :block
      t.string :room

      t.timestamps
    end
    add_index :economic_registrations, :person_id
    add_index :economic_registrations, :branch_classification_id
    add_index :economic_registrations, :issqn_classification_id
    add_index :economic_registrations, :branch_activity_id
    add_index :economic_registrations, :cnae_id
    add_index :economic_registrations, :list_service_id
    add_index :economic_registrations, :working_hour_id
    add_index :economic_registrations, :accountant_id
    add_index :economic_registrations, :street_id
    add_index :economic_registrations, :neighborhood_id
    add_index :economic_registrations, :district_id
    add_index :economic_registrations, :city_id
    add_index :economic_registrations, :state_id
    add_index :economic_registrations, :condominium_id

    add_foreign_key :economic_registrations, :people
    add_foreign_key :economic_registrations, :branch_classifications
    add_foreign_key :economic_registrations, :issqn_classifications
    add_foreign_key :economic_registrations, :branch_activities
    add_foreign_key :economic_registrations, :cnaes
    add_foreign_key :economic_registrations, :list_services
    add_foreign_key :economic_registrations, :working_hours
    add_foreign_key :economic_registrations, :accountants
    add_foreign_key :economic_registrations, :streets
    add_foreign_key :economic_registrations, :neighborhoods
    add_foreign_key :economic_registrations, :districts
    add_foreign_key :economic_registrations, :cities
    add_foreign_key :economic_registrations, :states
    add_foreign_key :economic_registrations, :condominiums
  end
end
