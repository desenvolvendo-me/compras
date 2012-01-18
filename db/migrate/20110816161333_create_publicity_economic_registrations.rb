class CreatePublicityEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table :publicity_economic_registrations do |t|
      t.references :economic_registration
      t.references :publicity
      t.string :process_number
      t.decimal :width, :precision => 10 , :scale => 2
      t.integer :quantity
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :publicity_economic_registrations, :economic_registration_id, :name => 'publicity_economic_registration_economic_idx'
    add_index :publicity_economic_registrations, :publicity_id
    add_foreign_key :publicity_economic_registrations, :economic_registrations, :name => 'publicity_economic_registration_economic_fk'
    add_foreign_key :publicity_economic_registrations, :publicities
  end
end
