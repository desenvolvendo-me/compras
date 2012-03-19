class RenameBidOpeningsToAdministrativeProcesses < ActiveRecord::Migration
  def change
    rename_table :bid_openings, :administrative_processes
  end
end
