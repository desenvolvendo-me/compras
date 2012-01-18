class CreateComplaintsAgain < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string :year
      t.integer :person_id
      t.timestamps
    end

    add_index :complaints, :person_id
    add_foreign_key :complaints, :people
  end
end
