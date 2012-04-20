class AddLicitationProcessIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :licitation_process_id, :integer

    add_index :pledges, :licitation_process_id
    add_foreign_key :pledges, :licitation_processes
  end
end
