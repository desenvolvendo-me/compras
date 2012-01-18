class CreateItemCostImprovements < ActiveRecord::Migration
  def change
    create_table :item_cost_improvements do |t|
      t.string :name
      t.references :reference_unit
      t.boolean :value, :default => false
      t.boolean :percentage, :default => false

      t.timestamps
    end
    add_index :item_cost_improvements, :reference_unit_id
    add_foreign_key :item_cost_improvements, :reference_units
  end
end
