class CreateLicitationProcesses < ActiveRecord::Migration
  def change
    create_table :licitation_processes do |t|
      t.references :bid_opening
      t.references :capability
      t.references :period
      t.references :payment_method
      t.integer :year
      t.date :process_date
      t.text :object_description
      t.string :expiration
      t.string :readjustment_index
      t.decimal :caution_value, :precision => 10, :scale => 2
      t.string :legal_advice
      t.date :legal_advice_date
      t.date :contract_date
      t.integer :contract_expiration
      t.text :observations

      t.timestamps
    end

    add_index :licitation_processes, :bid_opening_id
    add_index :licitation_processes, :capability_id
    add_index :licitation_processes, :period_id
    add_index :licitation_processes, :payment_method_id

    add_foreign_key :licitation_processes, :bid_openings
    add_foreign_key :licitation_processes, :capabilities
    add_foreign_key :licitation_processes, :periods
    add_foreign_key :licitation_processes, :payment_methods
  end
end
