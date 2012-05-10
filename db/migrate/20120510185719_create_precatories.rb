class CreatePrecatories < ActiveRecord::Migration
  def change
    create_table :precatories do |t|
      t.string :number
      t.string :lawsuit_number
      t.references :provider
      t.date :date
      t.date :judgment_date
      t.date :apresentation_date
      t.references :precatory_type
      t.text :historic

      t.timestamps
    end

    add_index :precatories, :provider_id
    add_index :precatories, :precatory_type_id

    add_foreign_key :precatories, :providers
    add_foreign_key :precatories, :precatory_types
  end
end
