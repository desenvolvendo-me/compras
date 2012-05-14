class CreatePledgeParcelMovimentations < ActiveRecord::Migration
  def change
    create_table :pledge_parcel_movimentations do |t|
      t.integer :pledge_parcel_id
      t.string :pledge_parcel_modificator_type
      t.integer :pledge_parcel_modificator_id
      t.decimal :pledge_parcel_value_was, :precision => 10, :scale => 2
      t.decimal :pledge_parcel_value, :precision => 10, :scale => 2
      t.decimal :value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :pledge_parcel_movimentations, :pledge_parcel_id

    add_foreign_key :pledge_parcel_movimentations, :pledge_parcels
  end
end
