class AddWarehouses < ActiveRecord::Migration
  def change
    create_table :compras_warehouses do |t|
      t.string :code
      t.string :name
      t.string :acronym
      t.timestamps
    end
  end
end
