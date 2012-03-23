class CreateLicitationProcessPublications < ActiveRecord::Migration
  def change
    create_table :licitation_process_publications do |t|
      t.references :licitation_process
      t.string :name
      t.date :publication_date
      t.string :publication_of
      t.string :circulation_type

      t.timestamps
    end

    add_index :licitation_process_publications, :licitation_process_id
    add_foreign_key :licitation_process_publications, :licitation_processes
  end
end
