class CreateLicitationNotices < ActiveRecord::Migration
  def change
    create_table :licitation_notices do |t|
      t.references :licitation_process
      t.integer :number
      t.date :date
      t.text :observations

      t.timestamps
    end

    add_index :licitation_notices, :licitation_process_id
    add_foreign_key :licitation_notices, :licitation_processes
  end
end
