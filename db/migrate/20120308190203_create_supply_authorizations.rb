class CreateSupplyAuthorizations < ActiveRecord::Migration
  def change
    create_table :supply_authorizations do |t|
      t.integer :year
      t.string :code
      t.references :direct_purchase

      t.timestamps
    end

    add_index :supply_authorizations, :direct_purchase_id
  end
end
