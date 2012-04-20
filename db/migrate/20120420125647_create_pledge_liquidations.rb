class CreatePledgeLiquidations < ActiveRecord::Migration
  def change
    create_table :pledge_liquidations do |t|
      t.references :pledge
      t.references :pledge_expiration
      t.decimal :value
      t.string :kind
      t.date :date

      t.timestamps
    end

    add_index :pledge_liquidations, :pledge_id
    add_index :pledge_liquidations, :pledge_expiration_id

    add_foreign_key :pledge_liquidations, :pledges
    add_foreign_key :pledge_liquidations, :pledge_expirations
  end
end
