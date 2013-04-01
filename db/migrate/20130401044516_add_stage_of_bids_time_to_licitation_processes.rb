class AddStageOfBidsTimeToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :stage_of_bids_time, :time
  end
end
