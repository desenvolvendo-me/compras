class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.integer :year
      t.integer :person_id
      t.integer :registrable_id
      t.string  :registrable_type

      t.timestamps
    end

    add_index :complaints, :person_id
    add_index :complaints, [:registrable_id, :registrable_type]
    add_foreign_key :complaints, :people
  end
end
