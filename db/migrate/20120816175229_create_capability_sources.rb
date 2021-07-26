class CreateCapabilitySources < ActiveRecord::Migration
  def change
    create_table :compras_capability_sources do |t|
      t.integer :code
      t.string :name
      t.text :specification
      t.string :source

      t.timestamps
    end
  end
end
