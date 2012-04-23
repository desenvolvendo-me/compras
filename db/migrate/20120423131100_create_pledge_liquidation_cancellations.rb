class CreatePledgeLiquidationCancellations < ActiveRecord::Migration
  def change
    create_table :pledge_liquidation_cancellations do |t|
      t.references :pledge
      t.references :pledge_expiration
      t.string :kind
      t.decimal :value, :precision => 10, :scale => 2
      t.date :date
      t.text :reason

      t.timestamps
    end

    add_index :pledge_liquidation_cancellations, :pledge_id
    add_index :pledge_liquidation_cancellations, :pledge_expiration_id

    add_foreign_key :pledge_liquidation_cancellations, :pledges
    add_foreign_key :pledge_liquidation_cancellations, :pledge_expirations
  end
end
