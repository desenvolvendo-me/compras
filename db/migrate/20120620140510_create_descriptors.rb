class CreateDescriptors < ActiveRecord::Migration
  def change
    create_table :compras_descriptors do |t|
      t.references :entity
      t.integer :year

      t.timestamps
    end

    add_index :compras_descriptors, :entity_id

    add_foreign_key :compras_descriptors, :compras_entities, :column => :entity_id
  end
end
