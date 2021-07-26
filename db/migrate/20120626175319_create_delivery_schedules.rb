class CreateDeliverySchedules < ActiveRecord::Migration
  def change
    create_table :compras_delivery_schedules do |t|
      t.references :contract
      t.date :scheduled_date
      t.date :delivery_date
      t.string :delivery_schedule_status
      t.text :observations
      t.integer :sequence

      t.timestamps
    end

    add_index :compras_delivery_schedules, :contract_id
    add_foreign_key :compras_delivery_schedules, :compras_contracts, :column => :contract_id
  end
end
