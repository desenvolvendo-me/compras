class CreatePledgeCancellations < ActiveRecord::Migration
  def change
    create_table :pledge_cancellations do |t|
      t.references :pledge
      t.references :pledge_expiration
      t.decimal :value_canceled
      t.string :kind
      t.decimal :value
      t.date :date
      t.string :nature
      t.text :reason

      t.timestamps
    end

    add_index :pledge_cancellations, :pledge_id
    add_index :pledge_cancellations, :pledge_expiration_id

    add_foreign_key :pledge_cancellations, :pledges
    add_foreign_key :pledge_cancellations, :pledge_expirations
  end
end
