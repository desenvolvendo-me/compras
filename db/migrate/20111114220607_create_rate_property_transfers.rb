class CreateRatePropertyTransfers < ActiveRecord::Migration
  def change
    create_table :rate_property_transfers do |t|
      t.integer :year
      t.decimal :value, :precision => 10, :scale => 2
      t.boolean :funded

      t.timestamps
    end
  end
end
