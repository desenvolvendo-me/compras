class ChangeReadjustmetIndexOfLicitationProcess < ActiveRecord::Migration
  def change
    remove_column :licitation_processes, :readjustment_index

    add_column :licitation_processes, :readjustment_index_id, :integer

    add_index :licitation_processes, :readjustment_index_id

    add_foreign_key :licitation_processes, :indexers, :column => :readjustment_index_id
  end
end
