class RenameColumnBidOpeningIdOnLicitationProcesses < ActiveRecord::Migration
  def change
    rename_column :licitation_processes, :bid_opening_id, :administrative_process_id
  end
end
