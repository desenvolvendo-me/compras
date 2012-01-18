class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :person
      t.references :motive
      t.integer :parcel_number
      t.date :date_agreement
      t.text :comment
      t.string :state
      t.string :process
      t.date :cancel_date
      t.references :currency

      t.timestamps
    end
    add_index :agreements, :person_id
    add_index :agreements, :motive_id
    add_index :agreements, :currency_id
    add_foreign_key :agreements, :people
    add_foreign_key :agreements, :motives
    add_foreign_key :agreements, :currencies
  end
end
