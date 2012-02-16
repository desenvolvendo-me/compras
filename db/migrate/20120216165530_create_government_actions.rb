class CreateGovernmentActions < ActiveRecord::Migration
  def change
    create_table :government_actions do |t|
      t.integer :year
      t.string :description
      t.string :status
      t.references :entity

      t.timestamps
    end
    add_index :government_actions, :entity_id
    add_foreign_key :government_actions, :entities
  end
end
