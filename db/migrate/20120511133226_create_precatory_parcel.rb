class CreatePrecatoryParcel < ActiveRecord::Migration
  def change
    create_table :precatory_parcels do |t|
      t.references :precatory
      t.date :expiration_date
      t.decimal :value, :precision => 10, :scale => 2
      t.string :situation
      t.date :payment_date
      t.decimal :amount_paid, :precision => 10, :scale => 2
      t.string :observation
    end

    add_index :precatory_parcels, :precatory_id

    add_foreign_key :precatory_parcels, :precatories
  end
end
