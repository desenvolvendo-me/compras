class CreateDirectPurchaseItems < ActiveRecord::Migration
  def change
    create_table :direct_purchase_items do |t|
      t.references :direct_purchase
      t.references :material
      t.string :brand
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :direct_purchase_items, :direct_purchase_id
    add_index :direct_purchase_items, :material_id
    add_foreign_key :direct_purchase_items, :direct_purchases
    add_foreign_key :direct_purchase_items, :materials
  end
end
