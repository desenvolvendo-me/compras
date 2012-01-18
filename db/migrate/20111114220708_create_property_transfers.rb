class CreatePropertyTransfers < ActiveRecord::Migration
  def change
    create_table :property_transfers do |t|
      t.integer :year
      t.integer :protocol_number
      t.integer :registry_code
      t.string :reason
      t.boolean :purchased_at_auction
      t.date :finish_date
      t.string :status
      t.date :transfer_date
      t.text :comment
      t.decimal :market_value_of_terrain, :precision => 10, :scale => 2
      t.decimal :market_value_of_construction, :precision => 10, :scale => 2
      t.decimal :percentage_of_sale, :precision => 10, :scale => 2, :default => 100.0
      t.decimal :declared_value_of_transaction, :precision => 10, :scale => 2
      t.decimal :amount_financed, :precision => 10, :scale => 2
      t.integer :buyer_id
      t.integer :property_id
      t.integer :rate_id
      t.integer :funded_rate_id

      t.timestamps
    end

    add_index :property_transfers, :buyer_id
    add_index :property_transfers, :property_id
    add_index :property_transfers, :rate_id
    add_index :property_transfers, :funded_rate_id
    add_foreign_key :property_transfers, :people, :column => :buyer_id
    add_foreign_key :property_transfers, :properties
    add_foreign_key :property_transfers, :rate_property_transfers, :column => :rate_id
    add_foreign_key :property_transfers, :rate_property_transfers, :column => :funded_rate_id
  end
end
