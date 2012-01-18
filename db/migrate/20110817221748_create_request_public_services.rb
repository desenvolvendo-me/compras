class CreateRequestPublicServices < ActiveRecord::Migration
  def change
    create_table :request_public_services do |t|
      t.string :code
      t.string :year
      t.references :person
      t.string :protocol_number
      t.date :date_request
      t.references :service_public_calculation
      t.text :description

      t.timestamps
    end
    add_index :request_public_services, :person_id
    add_index :request_public_services, :service_public_calculation_id
    add_foreign_key :request_public_services, :people
    add_foreign_key :request_public_services, :service_public_calculations
  end
end
