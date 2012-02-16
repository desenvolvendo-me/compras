class CreateGovernmentPrograms < ActiveRecord::Migration
  def change
    create_table :government_programs do |t|
      t.integer :entity_id
      t.integer :year
      t.string :description
      t.string :status

      t.timestamps
    end

    add_index :government_programs, :entity_id

    add_foreign_key :government_programs, :entities
  end
end
