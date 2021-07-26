class CreateCustomizationData < ActiveRecord::Migration
  def change
    create_table :compras_customization_data do |t|
      t.references :customization
      t.string :data
      t.string :data_type

      t.timestamps
    end
    add_index :compras_customization_data, :customization_id
    add_foreign_key :compras_customization_data, :compras_customizations, :column => :customization_id
  end
end
