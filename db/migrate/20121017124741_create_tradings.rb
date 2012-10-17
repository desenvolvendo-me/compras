class CreateTradings < ActiveRecord::Migration
  def change
    create_table :compras_tradings do |t|
      t.integer :code
      t.integer :year
      t.references :entity
      t.integer :licitating_unit_id
      t.string :summarized_object

      t.timestamps
    end

    add_index :compras_tradings, :entity_id
    add_index :compras_tradings, :licitating_unit_id

    add_foreign_key :compras_tradings, :compras_entities, :column => :entity_id
    add_foreign_key :compras_tradings, :compras_entities, :column => :licitating_unit_id
  end
end
