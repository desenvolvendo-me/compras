class CreateLicitationProcessLots < ActiveRecord::Migration
  def change
    create_table :licitation_process_lots do |t|
      t.references :licitation_process
      t.text :observations

      t.timestamps
    end

    add_index :licitation_process_lots, :licitation_process_id
    add_foreign_key :licitation_process_lots, :licitation_processes
  end
end
