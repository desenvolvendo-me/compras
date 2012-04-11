class CreateLicitationProcessAppeals < ActiveRecord::Migration
  def change
    create_table :licitation_process_appeals do |t|
      t.references :licitation_process
      t.date :appeal_date
      t.string :related
      t.references :person
      t.text :valid_reason
      t.text :licitation_committee_opinion
      t.string :situation

      t.timestamps
    end

    add_index :licitation_process_appeals, :licitation_process_id
    add_index :licitation_process_appeals, :person_id
    add_foreign_key :licitation_process_appeals, :licitation_processes
    add_foreign_key :licitation_process_appeals, :people
  end
end
