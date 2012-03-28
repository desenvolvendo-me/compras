class CreatePledgeExpirations < ActiveRecord::Migration
  def change
    create_table :pledge_expirations do |t|
      t.date :expiration_date
      t.decimal :value

      t.integer :pledge_id
    end

    add_index :pledge_expirations, :pledge_id

    add_foreign_key :pledge_expirations, :pledges
  end
end
