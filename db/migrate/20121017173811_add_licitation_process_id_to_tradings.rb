class AddLicitationProcessIdToTradings < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :licitation_process_id, :integer

    add_index :compras_tradings, :licitation_process_id

    add_foreign_key :compras_tradings, :compras_licitation_processes, :column => :licitation_process_id
  end
end
