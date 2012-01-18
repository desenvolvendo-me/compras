class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.integer :value
      t.references :field
      t.references :property

      t.timestamps
    end
    add_index :field_values, :field_id
    add_index :field_values, :property_id
  end
end
