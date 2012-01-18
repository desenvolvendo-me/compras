class CreateExemptionRequests < ActiveRecord::Migration
  def change
    create_table :exemption_requests do |t|
      t.references :exemption
      t.date :date, :default => Date.current
      t.integer :year
      t.references :revenue
      t.references :property
      t.text :description
      t.integer :situation, :default => 1
      t.date :situation_date, :default => Date.current
      t.references :motive
      t.text :opinion

      t.timestamps
    end

    add_index :exemption_requests, :exemption_id
    add_index :exemption_requests, :revenue_id
    add_index :exemption_requests, :property_id
    add_index :exemption_requests, :motive_id

    add_foreign_key :exemption_requests, :exemptions
    add_foreign_key :exemption_requests, :revenues
    add_foreign_key :exemption_requests, :properties
    add_foreign_key :exemption_requests, :motives
  end
end
