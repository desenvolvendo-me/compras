class CreatePurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :purchase_solicitations do |t|
      t.string :accounting_year
      t.date :request_date
      t.references :responsible
      t.text :justification
      t.references :budget_allocation
      t.decimal :allocation_amount
      t.references :delivery_location
      t.string :kind
      t.text :general_observations
      t.string :service_status
      t.date :liberation_date
      t.references :liberator
      t.text :service_observations
      t.text :no_service_justification

      t.timestamps
    end
    add_index :purchase_solicitations, :responsible_id
    add_index :purchase_solicitations, :budget_allocation_id
    add_index :purchase_solicitations, :delivery_location_id
    add_index :purchase_solicitations, :liberator_id

    add_foreign_key :purchase_solicitations, :employees, :column => :responsible_id
    add_foreign_key :purchase_solicitations, :budget_allocations
    add_foreign_key :purchase_solicitations, :delivery_locations
    add_foreign_key :purchase_solicitations, :employees, :column => :liberator_id
  end
end
