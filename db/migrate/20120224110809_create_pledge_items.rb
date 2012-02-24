class CreatePledgeItems < ActiveRecord::Migration
  def change
    create_table :pledge_items do |t|
      t.references :pledge
      t.references :material
      t.string :description
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :pledge_items, :pledge_id
    add_index :pledge_items, :material_id
    add_foreign_key :pledge_items, :pledges
    add_foreign_key :pledge_items, :materials
  end
end
