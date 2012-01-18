class RemoveComplaints < ActiveRecord::Migration
  def change
    remove_foreign_key :complaints, :people
    remove_index :complaints, [:registrable_id, :registrable_type]
    remove_index :complaints, :person_id
    drop_table :complaints
  end
end
