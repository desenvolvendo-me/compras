class CreateGraphics < ActiveRecord::Migration
  def change
    create_table :graphics do |t|
      t.references :person
      t.boolean :authorized
      t.date :registration_date
      t.date :cancellation_date
      t.text :comment

      t.timestamps
    end

    add_index :graphics, :person_id
    add_foreign_key :graphics, :people
  end
end
