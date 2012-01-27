class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.references :materials_group
      t.references :materials_class
      t.string :code
      t.string :name
      t.text :description
      t.integer :minimum_stock_balance
      t.integer :stock_balance
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.decimal :cash_balance, :precision => 10, :scale => 2
      t.references :reference_unit
      t.string :manufacturer
      t.boolean :perishable
      t.boolean :storable
      t.boolean :combustible
      t.string :material_characteristic
      t.references :service_type
      t.string :material_type
      t.string :stn_ordinance
      t.string :expense_element

      t.timestamps
    end
    add_index :materials, :materials_group_id
    add_index :materials, :materials_class_id
    add_index :materials, :reference_unit_id
    add_index :materials, :service_type_id

    add_foreign_key :materials, :materials_groups
    add_foreign_key :materials, :materials_classes
    add_foreign_key :materials, :reference_units
    add_foreign_key :materials, :service_types
  end
end
